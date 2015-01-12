import Foundation

public class Close: Message, Equatable {

    public let reason: String

    public init(reason: String) {
        self.reason = reason
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(type: 7, contents: xdr(reason)!)
    }

    override public class func decode(encodedMessage: EncodedMessage) -> Close? {
        let reader = XdrReader(xdrBytes: encodedMessage.contents);
        if let reason = reader.readString() {
            return Close(reason: reason)
        }
        return nil
    }

}

public func == (lhs: Close, rhs: Close) -> Bool {
    return lhs.reason == rhs.reason
}