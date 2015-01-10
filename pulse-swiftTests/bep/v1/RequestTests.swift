import XCTest
import Pulse

class RequestsTests : XCTestCase {

    let message = Request(
            repository: someRepository,
            name: someName,
            offset: someOffset,
            size: someSize
    ).encode()

    func testIsType2() {
        XCTAssertEqual(message.type, UInt8(2))
    }

    func testHasXdrEncodedFields() {
        let reader = XdrReader(xdrBytes: message.contents)
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