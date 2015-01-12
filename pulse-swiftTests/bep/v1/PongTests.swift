import XCTest
import Pulse

class PongTests : XCTestCase {

    var ping : Ping!
    var pong : Pong!

    override func setUp() {
        ping = Ping()
        pong = Pong(ping: ping!)
    }

    func testHasType5() {
        XCTAssertEqual(pong.encode().type, UInt8(5))
    }

    func testIsNotCompressed() {
        XCTAssertFalse(pong.encode().isCompressed)
    }

    func testHasSameIdAsPing() {
        XCTAssertEqual(pong.encode().id, ping.id)
    }

}

extension Pong {

    class var example: Pong {
        return Pong(ping: Ping())
    }

}
