import UIKit
import XCTest
import Security
import Pulse

class X509CertificateTests: XCTestCase {

    func testCreateSelfSignedCertificate() {
        let (cert, privateKey, publicKey) = createSelfSignedCertificate()

        let blockSize = SecKeyGetBlockSize(privateKey)
        println("\(blockSize)")
        XCTAssertEqual(UInt(128), blockSize)

        let subj = SecCertificateCopySubjectSummary(cert).takeUnretainedValue()
        println("\(subj)")

        let pubBlockSize = SecKeyGetBlockSize(publicKey)
        println("\(pubBlockSize)")
        XCTAssertEqual(UInt(128), pubBlockSize)
    }

    func createSelfSignedCertificate() -> (SecCertificate, SecKey, SecKey) {
        let pass = "pwd"
        let pkcs12Data: NSData? = createPKCS12BlobUsingOpenSSL(pass)

        let key: NSString = kSecImportExportPassphrase.takeRetainedValue() as NSString
        let options: NSDictionary = [key: pass]
        var items: Unmanaged<CFArray>?
        var status = SecPKCS12Import(pkcs12Data, options, &items);
        XCTAssertEqual(errSecSuccess, status)
        var its: NSArray = items!.takeUnretainedValue() as NSArray
        var objects = its[0] as NSDictionary
        var k2 = kSecImportItemIdentity.takeRetainedValue() as NSString
        let identity: SecIdentityRef? = objects[k2] as SecIdentityRef?
        k2 = kSecImportItemTrust.takeRetainedValue() as NSString
        let trust: SecTrustRef? = objects[k2] as SecTrustRef?
        let publicKey: SecKeyRef = SecTrustCopyPublicKey(trust!).takeUnretainedValue()
        var uCert: Unmanaged<SecCertificateRef>?
        status = SecIdentityCopyCertificate(identity!, &uCert)
        XCTAssertEqual(errSecSuccess, status)
        let cert: SecCertificateRef = uCert!.takeUnretainedValue()
        var uPrivateKey: Unmanaged<SecKey>?
        status = SecIdentityCopyPrivateKey(identity!, &uPrivateKey)
        XCTAssertEqual(errSecSuccess, status)
        let privateKey: SecKeyRef = uPrivateKey!.takeUnretainedValue()
        println("\(privateKey)")

        return (cert, privateKey, publicKey)
    }

    func createPKCS12BlobUsingOpenSSL(pass: String) -> NSData? {
        let serial:UInt = 0
        let days:UInt = 365
        let bits:UInt = 1024
        let cert:OpenSSLCertificate! = OpenSSLCertificate(serial: serial, days: days, bits: bits)
        XCTAssertTrue(cert.tryCreateSelfSignedCertificate())
        return cert.createPKCS12BlobWithPassword("pwd")
    }
}
