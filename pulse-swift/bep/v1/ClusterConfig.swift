import Foundation

public class ClusterConfig: Message {

    public init(clientName: String, clientVersion: String, folders: [Folder], options: Options) {
        let contents = XdrWriter()
            .writeString(clientName)
            .writeString(clientVersion)
            .write(folders)
            .write(options).xdrBytes
        super.init(type: 0, contents: contents)
    }
}