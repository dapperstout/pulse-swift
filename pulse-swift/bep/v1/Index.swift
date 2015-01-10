import Foundation

public class Index : Message {

    let folder: String
    let files: [FileInfo]

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

}
