import Foundation

public class Ping : Message {

    public init() {
        super.init(type: 4, contents: [], compress: false);
    }

}


