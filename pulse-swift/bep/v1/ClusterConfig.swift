import Foundation

public class ClusterConfig: Message, Equatable {

    public let clientName: String
    public let clientVersion: String
    public let folders: [Folder]
    public let options: Options

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

    override public class func decode(encodedMessage: EncodedMessage) -> ClusterConfig? {
        let reader = XdrReader(xdrBytes: encodedMessage.contents)
        if let clientName = reader.readString() {
        if let clientVersion = reader.readString() {
        if let folders = reader.read([Folder]) {
        if let options = reader.read(Options) {
            return ClusterConfig(
                clientName: clientName,
                clientVersion: clientVersion,
                folders: folders,
                options: options
            )
        }}}}
        return nil;
    }
}

public func == (lhs: ClusterConfig, rhs: ClusterConfig) -> Bool {
    return
        lhs.clientName == rhs.clientName &&
        lhs.clientVersion == rhs.clientVersion &&
        lhs.folders == rhs.folders &&
        lhs.options == rhs.options
}
