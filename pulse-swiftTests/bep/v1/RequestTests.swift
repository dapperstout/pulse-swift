import XCTest
import Pulse

class RequestsTests : XCTestCase {

    func testIsType2() {
        XCTAssertEqual(message.type, UInt8(2))
    }

    func testHasXdrEncodedFields() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readString()!, request.repository)
        XCTAssertEqual(reader.readString()!, request.name)
        XCTAssertEqual(reader.readUInt64()!, request.offset)
        XCTAssertEqual(reader.readUInt32()!, request.size)
    }

    let request = Request.example
    let message = Request.example.encode()

}

extension Request {

    class var example: Request {
        let someRepository = "Some Repository"
        let someName = "Some Name"
        let someOffset : UInt64 = 42
        let someSize : UInt32 = 3
        return Request(
            repository: someRepository,
            name: someName,
            offset: someOffset,
            size: someSize
        )
    }

}

