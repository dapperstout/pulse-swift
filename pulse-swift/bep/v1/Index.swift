import Foundation

public class Index : Message, Equatable {

    public let folder: String
    public let files: [FileInfo]

    public init(folder: String, files: [FileInfo]) {
        self.folder = folder
        self.files = files
    }

    override public func encode() -> EncodedMessage {
        return encode(type: 1)
    }

    func encode(#type: UInt8) -> EncodedMessage {
        let contents = XdrWriter()
            .writeString(folder)
            .write(files).xdrBytes
        return EncodedMessage(type: type, contents: contents)
    }

    override public class func decode(encodedMessage: EncodedMessage) -> Index? {
        let reader = XdrReader(xdrBytes: encodedMessage.contents)
        if let folder = reader.readString() {
        if let files = reader.read([FileInfo]) {
            return Index(folder: folder, files: files)
        }}
        return nil
    }
}

public func == (lhs: Index, rhs: Index) -> Bool {
    return
        lhs.folder == rhs.folder &&
        lhs.files == rhs.files
}
