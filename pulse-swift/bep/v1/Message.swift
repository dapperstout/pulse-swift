import Foundation

public class Message {

    // override in subclass
    public func encode() -> EncodedMessage {
        return EncodedMessage(type: 0)
    }

}