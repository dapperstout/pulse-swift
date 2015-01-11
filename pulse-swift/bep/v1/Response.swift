import Foundation

public class Response: Message, Equatable {

    public let id: UInt16
    public let data: [UInt8]

    public convenience init(request: Request, data: [UInt8]) {
        self.init(id: request.id, data: data)
    }

    public init(id: UInt16, data: [UInt8]) {
        self.id = id
        self.data = data
    }

    override public func encode() -> EncodedMessage {
        return EncodedMessage(id: id, type: 3, contents: xdr(data)!)
    }

    override public class func decode(encodedMessage: EncodedMessage) -> Response? {
        let reader = XdrReader(xdrBytes: encodedMessage.contents)
        if let data = reader.readData() {
            return Response(id: encodedMessage.id, data: data)
        }
        return nil
    }

}

public func == (lhs: Response, rhs: Response) -> Bool {
    return
        lhs.id == rhs.id &&
        lhs.data == rhs.data
}