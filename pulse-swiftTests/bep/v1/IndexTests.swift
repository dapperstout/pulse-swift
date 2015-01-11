import XCTest
import Pulse

class IndexTests : XCTestCase {

    func testIsType1() {
        XCTAssertEqual(message.type, UInt8(1))
    }

    func testHasXdrEncodedFolder() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readString()!, index.folder)
    }

    func testHasXdrEncodedFileInfo() {
        let reader = XdrReader(xdrBytes: message.contents)
        reader.readString()
        XCTAssertEqual(reader.read([FileInfo])!, index.files)
    }

    let index = Index.example
    let message = Index.example.encode()
}

extension Index {

    class var example: Index {
        let someFolder = "Some Folder"
        let someFiles = [FileInfo(name: "one"), FileInfo(name: "two")]
        return Index(folder: someFolder, files: someFiles)
    }

}

