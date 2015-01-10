import XCTest
import Pulse

class PingTests : XCTestCase {

    func testHasType4() {
        XCTAssertEqual(message.type, UInt8(4))
    }

    func testIsNotCompressed() {
        XCTAssertFalse(message.isCompressed)
    }

    let message = Ping().encode()

}
