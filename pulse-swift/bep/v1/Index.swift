import Foundation

public class Index : Message {

    public init(folder: String, files: [FileInfo]) {
        let contents = XdrWriter()
            .writeString(folder)
            .write(files).xdrBytes
        super.init(type: 1, contents: contents)
    }
}
