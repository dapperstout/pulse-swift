import XCTest
import syncthing

class PongTests : XCTestCase {

    var ping : Ping?
    var pong : Pong?

    override func setUp() {
        ping = Ping()
        pong = Pong(ping: ping!)
    }

    func testHasType5() {
        XCTAssertEqual(pong!.type, 5)
    }

    func testIsNotCompressed() {
        XCTAssertFalse(pong!.isCompressed)
    }

    func testHasSameIdAsPing() {
        XCTAssertEqual(ping!.id, pong!.id)
    }

}
