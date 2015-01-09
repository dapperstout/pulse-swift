import Foundation

public class Ping : EncodedMessage {

    public init() {
        super.init(type: 4, compress: false);
    }

}


