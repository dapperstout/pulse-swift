import Foundation

public class Message {

    // override in subclass
    public func encode() -> EncodedMessage {
        return EncodedMessage(type: 255)
    }

    public class func decode(encodedMessage: EncodedMessage) -> Message? {
        switch(encodedMessage.type) {
            case 0:
                return ClusterConfig.decode(encodedMessage)
            case 1:
                return Index.decode(encodedMessage)
            case 2:
                return Request.decode(encodedMessage)
            case 3:
                return Response.decode(encodedMessage)
            case 4:
                return Ping.decode(encodedMessage)
            case 5:
                return Pong.decode(encodedMessage)
            case 6:
                return IndexUpdate.decode(encodedMessage)
            default:
                return nil
        }
    }

}