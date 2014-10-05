import Foundation

public class Close : Message {

    public init(reason : String) {
        let contents = XdrWriter().writeString(reason).xdrBytes
        super.init(type:7, contents:contents)
    }

}