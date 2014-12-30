import XCTest
import Pulse

class PingTests : XCTestCase {

    let ping = Ping()

    func testHasType4() {
        XCTAssertEqual(ping.type, UInt8(4))
    }

    func testIsNotCompressed() {
        XCTAssertFalse(ping.isCompressed)
    }

}
