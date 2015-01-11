import Foundation

public class Ping : Message, Equatable {

    var encodedMessage: EncodedMessage?

    override public init() {
        super.init()
    }

    init(encodedMessage: EncodedMessage) {
        super.init()
        self.encodedMessage = encodedMessage
    }

    override public func encode() -> EncodedMessage {
        if (encodedMessage == nil) {
            encodedMessage = EncodedMessage(type: 4, compress: false)
        }
        return encodedMessage!
    }

    override public class func decode(encodedMessage: EncodedMessage) -> Ping? {
        return Ping(encodedMessage: encodedMessage)
    }

    public var id: UInt16 {
        return encode().id
    }
}

public func == (lhs: Ping, rhs: Ping) -> Bool {
    return lhs.id == rhs.id
}
