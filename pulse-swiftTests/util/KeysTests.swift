import XCTest
import pulse

class KeysTests: XCTestCase {

    var keys: Keys!
    var securityFunctions: SecurityFunctionsMock!
    var somePrivateKey: SecKey!
    var somePublicKey: SecKey!

    override func setUp() {
        keys = Keys()
        securityFunctions = SecurityFunctionsMock()
        keys.SecurityFunctions = securityFunctions
        setUpKeys()
    }

    func setUpKeys() {
        var privateKey: Unmanaged<SecKey>?
        var publicKey: Unmanaged<SecKey>?
        let parameters = [
                String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
                String(kSecAttrKeySizeInBits): 512
        ]
        SecKeyGeneratePair(parameters, &publicKey, &privateKey)
        somePublicKey = publicKey!.takeRetainedValue()
        somePrivateKey = privateKey!.takeRetainedValue()
    }

    func testShouldCreateSelfSignedCertificate() {
        securityFunctions.returnedPublicKey = somePublicKey
        securityFunctions.returnedPrivateKey = somePrivateKey
        securityFunctions.returnedStatus = errSecSuccess

        let (publicKey, privateKey) = keys.generateKeyPair()!

        XCTAssertTrue(somePublicKey === publicKey)
        XCTAssertTrue(somePrivateKey === privateKey)
    }

    func testShouldGenerate2048BitRSAKey() {
        securityFunctions.expectedParameters = [
            String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
            String(kSecAttrKeySizeInBits): 2048
        ]

        keys.generateKeyPair()
    }

    func testShouldReturnNilWhenOSStatusIsNotZero() {
        securityFunctions.returnedPublicKey = somePublicKey
        securityFunctions.returnedPrivateKey = somePrivateKey
        securityFunctions.returnedStatus = 42

        XCTAssertTrue(keys.generateKeyPair() == nil)
    }

    func testShouldReturnNilWhenPublicKeyIsNil() {
        securityFunctions.returnedPublicKey = nil
        securityFunctions.returnedPrivateKey = somePrivateKey
        securityFunctions.returnedStatus = errSecSuccess

        XCTAssertTrue(keys.generateKeyPair() == nil)
    }

    func testShouldReturnNilWhenPrivateKeyIsNil() {
        securityFunctions.returnedPublicKey = somePublicKey
        securityFunctions.returnedPrivateKey = nil
        securityFunctions.returnedStatus = errSecSuccess

        XCTAssertTrue(keys.generateKeyPair() == nil)
    }
}