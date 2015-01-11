import Foundation

public class Request : Message, Equatable {

    public let repository: String
    public let name: String
    public let offset: UInt64
    public let size: UInt32

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

    override public class func decode(encodedMessage: EncodedMessage) -> Request? {
        let reader = XdrReader(xdrBytes: encodedMessage.contents)
        if let repository = reader.readString() {
        if let name = reader.readString() {
        if let offset = reader.readUInt64() {
        if let size = reader.readUInt32() {
            return Request(repository: repository, name: name, offset: offset, size: size)
        }}}}
        return nil
    }

    public var id: UInt16 {
        return encode().id
    }

}

public func == (lhs: Request, rhs: Request) -> Bool {
    return
        lhs.repository == rhs.repository &&
        lhs.name == rhs.name &&
        lhs.offset == rhs.offset &&
        lhs.size == rhs.size
}