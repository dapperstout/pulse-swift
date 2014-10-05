import XCTest
import syncthing

class RequestsTests : XCTestCase {

    let request = Request(
            repository: someRepository,
            name: someName,
            offset: someOffset,
            size: someSize
    )

    func testIsType2() {
        XCTAssertEqual(request.type, 2)
    }

    func testHasXdrEncodedFields() {
        let reader = XdrReader(xdrBytes: request.contents)
        XCTAssertEqual(reader.readString()!, someRepository)
        XCTAssertEqual(reader.readString()!, someName)
        XCTAssertEqual(reader.readUInt64()!, someOffset)
        XCTAssertEqual(reader.readUInt32()!, someSize)
    }

}

let someRepository = "Some Repository"
let someName = "Some Name"
let someOffset : UInt64 = 42
let someSize : UInt32 = 3