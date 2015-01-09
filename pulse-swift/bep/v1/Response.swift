import Foundation

public class Response : EncodedMessage {

    public init(request : Request, data : [UInt8]) {
        super.init(id: request.id, type: 2, contents: xdr(data)!)
    }

}