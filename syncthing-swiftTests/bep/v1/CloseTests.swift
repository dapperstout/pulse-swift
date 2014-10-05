import XCTest
import syncthing

class CloseTests : XCTestCase {

    let close = Close(reason: someReason)

    func testHasType7() {
        XCTAssertEqual(close.type, 7)
    }

    func testHasXdrEncodedReason() {
        let reason = extractReasonFromClose()
        XCTAssertEqual(reason, someReason)
    }

    func extractReasonFromClose() -> String {
        let reader = XdrReader(xdrBytes: close.contents)
        return reader.readString()!
    }

}

let someReason = "some reason"
