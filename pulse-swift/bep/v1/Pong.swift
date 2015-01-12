import Foundation

public class Pong : Message, Equatable {

    let id: UInt16

    public convenience init(ping : Ping) {
        self.init(id: ping.id)
    }

    public init(id: UInt16) {
        self.id = id
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(id: id, type: 5, compress: false)
    }

    override public class func decode(encodedMessage: EncodedMessage) -> Pong? {
        return Pong(id: encodedMessage.id)
    }

}

public func == (lhs: Pong, rhs: Pong) -> Bool {
    return lhs.id == rhs.id
}
