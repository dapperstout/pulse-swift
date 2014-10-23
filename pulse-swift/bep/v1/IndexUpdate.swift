import Foundation

public class IndexUpdate: Index {

    public init(folder: String, files: [FileInfo]) {
        super.init(type: 6, folder: folder, files: files)
    }

}