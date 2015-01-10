import XCTest
import Pulse

class CloseTests : XCTestCase {

    let message = Close(reason: someReason).encode()

    func testHasType7() {
        XCTAssertEqual(message.type, UInt8(7))
    }

    func testHasXdrEncodedReason() {
        let reason = extractReasonFromClose()
        XCTAssertEqual(reason, someReason)
    }

    func extractReasonFromClose() -> String {
        let reader = XdrReader(xdrBytes: message.contents)
        return reader.readString()!
    }

}

let someReason = "some reason"
