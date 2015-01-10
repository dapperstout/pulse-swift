import Foundation

public class Pong : Message {

    let ping: Ping

    public init(ping : Ping) {
        self.ping = ping
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(id: ping.id, type: 5, compress: false)
    }

}
