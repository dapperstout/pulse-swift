import XCTest
import Pulse

class SecurityFunctionsMock: SecurityFunctions {

    var returnedPublicKey: SecKey?
    var returnedPrivateKey: SecKey?
    var returnedStatus: OSStatus = 0

    var expectedParameters: CFDictionary?

    override func SecKeyGeneratePair(parameters: CFDictionary!, var publicKey: UnsafeMutablePointer<Unmanaged<SecKey>?>, var privateKey: UnsafeMutablePointer<Unmanaged<SecKey>?>) -> OSStatus {
        if expectedParameters != nil {
            XCTAssertEqual(parameters as NSDictionary, expectedParameters!)
        }
        if returnedPublicKey != nil {
            publicKey.memory =  Unmanaged.passUnretained(returnedPublicKey!)
        }
        if returnedPrivateKey != nil {
            privateKey.memory = Unmanaged.passUnretained(returnedPrivateKey!)
        }
        return returnedStatus
    }
}