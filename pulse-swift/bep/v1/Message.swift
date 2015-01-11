import Foundation

public class Message {

    // override in subclass
    public func encode() -> EncodedMessage {
        return EncodedMessage(type: 255)
    }

    // override in subclass
    public class func decode(encodedMessage: EncodedMessage) -> Message? {
        switch(encodedMessage.type) {
            case 0:
                return ClusterConfig.decode(encodedMessage)
            case 1:
                return Index.decode(encodedMessage)
            default:
                return nil
        }
    }

}