import Foundation

public class Request : EncodedMessage {

    public init(repository: String, name: String, offset: UInt64, size: UInt32) {
        super.init(type: 2, contents: xdr(repository, name, offset, size)!)
    }

}