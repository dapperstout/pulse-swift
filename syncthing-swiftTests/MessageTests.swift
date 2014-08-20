import XCTest
import syncthing

class MessageTests : XCTestCase {

    func testVersionIsZero() {
        let bytes = SomeMessage().serialize()
        let firstNibble = nibbles(bytes[0]).0
        XCTAssertEqual(firstNibble, 0)
    }

    func testIdIsUnique() {
        var previousIds : [UInt16 : UInt16] = [:]
        for _ in 0..<4096 {
            let bytes = SomeMessage().serialize()
            let id = concatenateBytes(nibbles(bytes[0]).1, bytes[1])
            XCTAssertTrue(previousIds[id] == nil)
            previousIds[id] = id
        }
    }

    func testIsEncodedInThirdByte() {
        let message = Message(type: 3)
        let type = message.serialize()[2]
        XCTAssertEqual(type, 3)
    }

}

class SomeMessage : Message {
    init() {
        super.init(type: 0)
    }
}
