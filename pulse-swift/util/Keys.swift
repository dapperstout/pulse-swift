public class Keys {

    public typealias PublicAndPrivateKey = (SecKey, SecKey)

    public init() {}

    public func generateKeyPair() -> PublicAndPrivateKey? {
        var publicKey: Unmanaged<SecKey>?
        var privateKey: Unmanaged<SecKey>?
        let parameters = [
                String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
                String(kSecAttrKeySizeInBits): 2048
        ]

        let resultCode = SecurityFunctions.SecKeyGeneratePair(parameters, publicKey: &publicKey, privateKey: &privateKey)

        if resultCode == errSecSuccess && publicKey != nil && privateKey != nil  {
            return (publicKey!.takeRetainedValue(), privateKey!.takeRetainedValue());
        }
        return nil
    }

    public var SecurityFunctions = pulse.SecurityFunctions()
}