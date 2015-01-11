import Foundation

public class IndexUpdate: Index {

    override public func encode() -> EncodedMessage {
        return encode(type: 6)
    }

    override public class func decode(encodedMessage: EncodedMessage) -> IndexUpdate? {
        if let index = super.decode(encodedMessage) {
            return IndexUpdate(folder: index.folder, files: index.files)
        }
        return nil
    }

}