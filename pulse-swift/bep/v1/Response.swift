import Foundation

public class Response: Message {

    let request: Request
    let data: [UInt8]

    public init(request: Request, data: [UInt8]) {
        self.request = request
        self.data = data
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(id: request.id, type: 2, contents: xdr(data)!)
    }

}