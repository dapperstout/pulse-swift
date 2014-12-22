public class SecurityFunctions {

    public init() {}

    public func SecKeyGeneratePair(parameters: CFDictionary!, publicKey: UnsafeMutablePointer<Unmanaged<SecKey>?>, privateKey: UnsafeMutablePointer<Unmanaged<SecKey>?>) -> OSStatus {
        return Foundation.SecKeyGeneratePair(parameters, publicKey, privateKey)
    }
}

