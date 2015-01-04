Method A: Generate in iOS -> not possible?
-------------------------
1. Create keypair using Sec [done `SecKeyGeneratePair`]
2. Export public key
3. Export private key (can this be done on iOS??)
4. Import public key into OpenSSL
5. Import private key into OpenSSL
6. Create X509 certificate in OpenSSL
7. Export X509 certificate
8. Import certificate into Sec and keychain

Method B: Generate in OpenSSL -> implemented
-----------------------------
1. Create keypair using OpenSSL [done]
2. Create certificate using OpenSSL [done]
3. Store public key, private key and certificate in PKCS12 blob [`PKCS12_create`]
4. Import PKCS12 blob into Sec [`SecPKCS12Import`]

Links
-----
* [Certificate properties such as constraints, usage, extended usage](https://www.openssl.org/docs/apps/x509v3_config.html#basic_constraints_)
* [Some (incomplete?) code for creating self-signed certificate (combination of Sec and OpenSSL)] (http://stackoverflow.com/questions/14072051/generating-a-self-signed-certificate-with-ios-security-framework)
* [Get public key out of OpenSSL X509 certificate and convert X509 to DER encoded certificate](http://stackoverflow.com/questions/15032338/extract-public-key-of-a-der-encoded-certificate-in-c) -> method B
* [Info in OpenSSL BIO stuff](https://shanetully.com/2012/04/simple-public-key-encryption-with-rsa-and-openssl/)
* [Sec API method to get public key from DER encoded data and private key from P12 (pkcs12) encoded data](http://stackoverflow.com/questions/10579985/how-can-i-get-seckeyref-from-der-pem-file) -> method B
* [Get RSA public key from OpenSSL into Sec](http://blog.flirble.org/2011/01/05/rsa-public-key-openssl-ios/) -> method B
* [Hints about getting private key from OpenSSL into Sec](http://blog.wingsofhermes.org/?p=75) -> method B
* [Code for getting publica and private key from OpenSSL into Sec](https://github.com/kuapay/iOS-Certificate--Key--and-Trust-Sample-Project) -> method B
* [More on manually manipulating ASN headers in order to get keys into Sec](http://stackoverflow.com/questions/9728799/using-an-rsa-public-key-on-ios/16096064#16096064) -> method B
* [Apple says to use PKCS12 for importing keys and certificates](https://devforums.apple.com/message/684705#684705) -> method A and B

Reference
---------
* [iOS Certificate, Key and Trust Services Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/certifkeytrustservices/#//apple_ref/c/tdef/SecCertificateRef)


Guides
------
* [Cryptographic Services Guide](https://developer.apple.com/library/mac/documentation/Security/Conceptual/cryptoservices/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011172-CH1-SW1)
* [iOS Security Overview](https://developer.apple.com/library/ios/documentation/Security/Conceptual/Security_Overview/CryptographicServices/CryptographicServices.html#//apple_ref/doc/uid/TP30000976-CH3-SW5)
