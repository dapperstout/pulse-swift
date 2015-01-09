import Foundation

public class Close : EncodedMessage {

    public init(reason : String) {
        super.init(type:7, contents:xdr(reason)!)
    }

}