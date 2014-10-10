import Foundation

public class Close : Message {

    public init(reason : String) {
        super.init(type:7, contents:xdr(reason)!)
    }

}