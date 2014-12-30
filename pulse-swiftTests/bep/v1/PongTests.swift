import XCTest
import Pulse

class PongTests : XCTestCase {

    var ping : Ping?
    var pong : Pong?

    override func setUp() {
        ping = Ping()
        pong = Pong(ping: ping!)
    }

    func testHasType5() {
        XCTAssertEqual(pong!.type, UInt8(5))
    }

    func testIsNotCompressed() {
        XCTAssertFalse(pong!.isCompressed)
    }

    func testHasSameIdAsPing() {
        XCTAssertEqual(ping!.id, pong!.id)
    }

}
