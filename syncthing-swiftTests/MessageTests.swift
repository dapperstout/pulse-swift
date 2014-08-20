import XCTest
import syncthing

class MessageTests : XCTestCase {

    func testVersionIsZero() {
        let message : Message = Message()
        let bytes : [Byte] = message.serialize()
        XCTAssertEqual(bytes[0], 0)
    }

}
