import XCTest
import syncthing

class MessageTests : XCTestCase {

    func testVersionIsZero() {
        let bytes = Message().serialize()
        let firstNibble = nibbles(bytes[0]).0
        XCTAssertEqual(firstNibble, 0)
    }

}
