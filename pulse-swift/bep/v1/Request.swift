import Foundation

public class Request : Message {

    let repository: String
    let name: String
    let offset: UInt64
    let size: UInt32

    var encodedMessage: EncodedMessage?

    public init(repository: String, name: String, offset: UInt64, size: UInt32) {
        self.repository = repository
        self.name = name
        self.offset = offset
        self.size = size
    }

    override public func encode() -> EncodedMessage {
        if (encodedMessage == nil) {
            encodedMessage = EncodedMessage(type: 2, contents: xdr(repository, name, offset, size)!)
        }
        return encodedMessage!
    }

    public var id: UInt16 {
        return encode().id
    }

}