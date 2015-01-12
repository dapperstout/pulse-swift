import XCTest
import Pulse

class CloseTests : XCTestCase {

    func testHasType7() {
        XCTAssertEqual(message.type, UInt8(7))
    }

    func testHasXdrEncodedReason() {
        let reason = extractReasonFromClose()
        XCTAssertEqual(reason, close.reason)
    }

    func extractReasonFromClose() -> String {
        let reader = XdrReader(xdrBytes: message.contents)
        return reader.readString()!
    }

    let close = Close.example
    let message = Close.example.encode()

}

extension Close {

    class var example: Close {
        let someReason = "some reason"
        return Close(reason: someReason)
    }

}

