import Foundation

public class Message {

    // override in subclass
    public func encode() -> EncodedMessage {
        return EncodedMessage(type: 255)
    }

    // override in subclass
    public class func decode(encodedMessage: EncodedMessage) -> Message? {
        return ClusterConfig.decode(encodedMessage)
    }

}