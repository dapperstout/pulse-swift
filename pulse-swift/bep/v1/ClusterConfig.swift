import Foundation

public class ClusterConfig: Message {

    let clientName: String
    let clientVersion: String
    let folders: [Folder]
    let options: Options

    public init(clientName: String, clientVersion: String, folders: [Folder], options: Options) {
        self.clientName = clientName
        self.clientVersion = clientVersion
        self.folders = folders
        self.options = options
    }

    override public func encode() -> EncodedMessage {
        let contents = XdrWriter()
            .writeString(clientName)
            .writeString(clientVersion)
            .write(folders)
            .write(options).xdrBytes
        return EncodedMessage(type: 0, contents: contents)
    }
}