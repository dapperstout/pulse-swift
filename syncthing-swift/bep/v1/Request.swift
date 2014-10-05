import Foundation

public class Request : Message {

    public init(repository: String, name: String, offset : UInt64, size : UInt32) {
        let contents = XdrWriter()
            .writeString(repository)
            .writeString(name)
            .writeUInt64(offset)
            .writeUInt32(size).xdrBytes

        super.init(type: 2, contents: contents)
    }

}