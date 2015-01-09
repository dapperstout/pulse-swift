import Foundation

public class Pong : EncodedMessage {

    public init(ping : Ping) {
        super.init(id: ping.id, type: 5, compress: false)
    }

}
