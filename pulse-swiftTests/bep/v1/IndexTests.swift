import XCTest
import pulse

class IndexTests : XCTestCase {

    func testIsType1() {
        XCTAssertEqual(someIndex.type, UInt8(1))
    }

    func testHasXdrEncodedFolder() {
        let reader = XdrReader(xdrBytes: someIndex.contents)
        XCTAssertEqual(reader.readString()!, someFolder)
    }

    func testHasXdrEncodedFileInfo() {
        let reader = XdrReader(xdrBytes: someIndex.contents)
        reader.readString()
        XCTAssertEqual(reader.read([FileInfo])!, someFiles)
    }

    let someIndex = Index(folder: someFolder, files: someFiles)
}

let someFolder = "Some Folder"
let someFiles = [
    FileInfo(name: "one"),
    FileInfo(name: "two")
]