import XCTest
import syncthing

class PingTests : XCTestCase {

    let ping = Ping()

    func testHasType4() {
        XCTAssertEqual(ping.type, 4)
    }

    func testIsNotCompressed() {
        XCTAssertFalse(ping.isCompressed)
    }

}
