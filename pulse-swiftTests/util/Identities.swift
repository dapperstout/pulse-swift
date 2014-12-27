import Foundation

class Identities {

    func example() -> SecIdentity {
        return read("identity.p12", passphrase: "test")
    }

    func read(pkcs12File: String, passphrase: String) -> SecIdentity {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(pkcs12File, ofType: nil)!
        let data = NSData(contentsOfFile: path)!

        var importedItems: Unmanaged<CFArray>?
        let options = [String(kSecImportExportPassphrase.takeRetainedValue()): passphrase]
        SecPKCS12Import(data, options, &importedItems)

        let importedItemsArray = importedItems!.takeRetainedValue() as NSArray
        let dict = importedItemsArray[0] as NSDictionary
        let identity = dict[String(kSecImportItemIdentity.takeRetainedValue())] as SecIdentity

        return identity
    }
}