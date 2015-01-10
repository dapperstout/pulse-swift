import Foundation

public class Ping : Message {

    var encodedMessage: EncodedMessage?

    override public init() {
        super.init()
    }

    override public func encode() -> EncodedMessage {
        if (encodedMessage == nil) {
            encodedMessage = EncodedMessage(type: 4, compress: false)
        }
        return encodedMessage!
    }

    public var id: UInt16 {
        return encode().id
    }
}


