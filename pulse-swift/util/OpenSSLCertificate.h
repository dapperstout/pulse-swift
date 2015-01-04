//
// Created by Stefan on 04/01/15.
//

#import <Foundation/Foundation.h>

@interface OpenSSLCertificate : NSObject
- (instancetype)initWithSerial:(NSUInteger)serial days:(NSUInteger)days bits:(NSUInteger)bits;
- (BOOL)tryCreateSelfSignedCertificate;
- (NSData *)createPKCS12BlobWithPassword:(NSString *)password;
@end