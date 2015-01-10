import Foundation

public class IndexUpdate: Index {

    override public func encode() -> EncodedMessage {
        return encode(type: 6)
    }

}