import Foundation

public class Index : Message {

    public convenience init(folder: String, files: [FileInfo]) {
        self.init(type: 1, folder: folder, files: files)
    }

    init(type: UInt8, folder: String, files: [FileInfo]) {
        let contents = XdrWriter()
            .writeString(folder)
            .write(files).xdrBytes
        super.init(type: type, contents: contents)
    }

}
