//
// Created by Stefan on 04/01/15.
//

#import "OpenSSLCertificate.h"

#include <openssl/pkcs12.h>
#include <openssl/x509v3.h>


static unsigned char *const DEFAULT_CERTIFICATE_COMMON_NAME = (unsigned char * const)"Pulse";

static const int MAX_PASS_SIZE = 1024;

@interface OpenSSLCertificate ()
@property(nonatomic) NSUInteger serial;
@property(nonatomic) NSUInteger days;
@property(nonatomic) NSUInteger bits;
@property(nonatomic) EVP_PKEY *pkey;
@property(nonatomic) X509 *x509;
@end

@implementation OpenSSLCertificate

- (instancetype)initWithSerial:(NSUInteger)serial days:(NSUInteger)days bits:(NSUInteger)bits {
    if (self = [super init]) {
        self.serial = serial;
        self.days = days;
        self.bits = bits;
        CRYPTO_mem_ctrl(CRYPTO_MEM_CHECK_ON);
    }
    return self;
}

- (void)dealloc {
    [self cleanup];
}


- (BOOL)tryCreateSelfSignedCertificate {
    if (self.pkey || self.x509) {
        return NO; // todo document can be done only once
    }
    
    self.pkey = EVP_PKEY_new();
    self.x509 = X509_new();
    
    RSA *rsa = RSA_generate_key((int)self.bits, RSA_F4, NULL, NULL);
    if (RSA_check_key(rsa) != 1) {
        // todo return info about error?
        return NO;
    }

    if (!EVP_PKEY_assign_RSA(self.pkey, rsa)) {
        return NO;
    }
    rsa = NULL;

    X509_set_version(self.x509, 2);
    ASN1_INTEGER_set(X509_get_serialNumber(self.x509), (long) self.serial);
    X509_gmtime_adj(X509_get_notBefore(self.x509), 0);
    X509_gmtime_adj(X509_get_notAfter(self.x509), (long) (60 * 60 * 24 * self.days));
    X509_set_pubkey(self.x509, self.pkey);

    X509_NAME *name = X509_get_subject_name(self.x509);

    X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, DEFAULT_CERTIFICATE_COMMON_NAME, -1, -1, 0);

    /* Its self signed so set the issuer name to be the same as the
      * subject.
     */
    X509_set_issuer_name(self.x509, name);

    [self addExtension:NID_basic_constraints value:"CA:TRUE"]; // todo: critical not needed?
    [self addExtension:NID_key_usage value:"digitalSignature,keyEncipherment"]; // todo: critical not needed?
    [self addExtension:NID_ext_key_usage value:"serverAuth,clientAuth"]; // todo: critical not needed?

    return X509_sign(self.x509, self.pkey, EVP_md5()) != 0;
}

- (BOOL)addExtension:(int)nid value:(char *)value {
    X509_EXTENSION *ex;
    X509V3_CTX ctx;
    /* This sets the 'context' of the extensions. */
    /* No configuration database */
    X509V3_set_ctx_nodb(&ctx);
    /* Issuer and subject certs: both the target since it is self signed,
     * no request and no CRL
     */
    X509V3_set_ctx(&ctx, self.x509, self.x509, NULL, NULL, 0);
    ex = X509V3_EXT_conf_nid(NULL, &ctx, nid, value);
    if (!ex) {
        return NO;
    }

    X509_add_ext(self.x509, ex, -1);
    X509_EXTENSION_free(ex);
    return YES;

}

- (NSData*)createPKCS12BlobWithPassword:(NSString*)password {
    if (!self.pkey || !self.x509 || ![password canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        return nil;
    }
    
    OpenSSL_add_all_algorithms(); // todo: don't add ALL of them, as the binary can become large
    OpenSSL_add_all_ciphers(); // todo: don't add ALL of them, as the binary can become large
    OpenSSL_add_all_digests(); // todo: don't add ALL of them, as the binary can become large

    char *pwd = malloc(sizeof(char) * MAX_PASS_SIZE);
    if (![password getCString:pwd maxLength:MAX_PASS_SIZE-1 encoding:NSASCIIStringEncoding]) {
        return nil;
    }

    PKCS12 *pkcs12 = PKCS12_create(pwd, "selfsigned", self.pkey, self.x509, NULL, 0, 0, 0, 0, 0);
    if (!pkcs12) {
        return nil;
    }

    int pkcs12Length = i2d_PKCS12(pkcs12, NULL);
    if (pkcs12Length <= 0) {
        return nil;
    }
    unsigned char *buffer = malloc(sizeof(unsigned char)* pkcs12Length);
    unsigned char *tmp = buffer;
    i2d_PKCS12(pkcs12, &tmp);
    NSAssert(tmp-buffer == pkcs12Length, @"Sizes must match");
    NSData *pkcs12Data = [NSData dataWithBytes:buffer length:(NSUInteger) pkcs12Length];
    
    free(buffer);
    free(pwd);
    
    return pkcs12Data;
}

- (void)cleanup {
    if (self.x509) {
        X509_free(self.x509);
        self.x509 = NULL;
    }
    if (self.pkey) {
        EVP_PKEY_free(self.pkey);
        self.pkey = NULL;
    }
}

@end