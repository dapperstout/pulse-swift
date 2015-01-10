import Foundation

public class Close: Message {

    let reason: String

    public init(reason: String) {
        self.reason = reason
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(type: 7, contents: xdr(reason)!)
    }

}