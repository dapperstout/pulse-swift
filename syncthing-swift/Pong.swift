import Foundation

public class Pong : Message {

    public init(ping : Ping) {
        super.init(id: ping.id, type: 5, contents: [], compress: false)
    }

}
