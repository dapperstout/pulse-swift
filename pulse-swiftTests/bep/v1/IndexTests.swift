import XCTest
import Pulse

class IndexTests : XCTestCase {

    func testIsType1() {
        XCTAssertEqual(message.type, UInt8(1))
    }

    func testHasXdrEncodedFolder() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readString()!, someFolder)
    }

    func testHasXdrEncodedFileInfo() {
        let reader = XdrReader(xdrBytes: message.contents)
        reader.readString()
        XCTAssertEqual(reader.read([FileInfo])!, someFiles)
    }

    let message = Index(folder: someFolder, files: someFiles).encode()
}

let someFolder = "Some Folder"
let someFiles = [
    FileInfo(name: "one"),
    FileInfo(name: "two")
]