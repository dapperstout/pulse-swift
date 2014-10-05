import XCTest
import syncthing

class MessageTests : XCTestCase {

    func testVersionIsZero() {
        let bytes = SomeMessage().serialize()
        let firstNibble = nibbles(bytes[0])[0]
        XCTAssertEqual(firstNibble, 0)
    }

    func testIdIsUnique() {
        var previousIds : [UInt16 : UInt16] = [:]
        for _ in 0..<4096 {
            let bytes = SomeMessage().serialize()
            let id = concatenateBytes(nibbles(bytes[0])[1], bytes[1])
            XCTAssertTrue(previousIds[id] == nil)
            previousIds[id] = id
        }
    }

    func testTypeIsEncodedInThirdByte() {
        let message = Message(type: 3)
        let type = message.serialize()[2]
        XCTAssertEqual(type, 3)
    }

    func testReservedBitsAreZero() {
        let message = SomeMessage()
        let reservedBits = bits(message.serialize()[3])
        for i in 0..<7 {
            XCTAssertFalse(reservedBits[i])
        }
    }

    func testCompressionIsEnabledByDefault() {
        let message = SomeMessage()
        let isCompressed = bits(message.serialize()[3])[7]
        XCTAssertTrue(isCompressed)
    }

    func testCompressionIsIndicatedInLastBitOfFourthByte() {
        let message = Message(type: 0, compress: false)
        let isCompressed = bits(message.serialize()[3])[7]
        XCTAssertFalse(isCompressed)
    }

    func testUncompressedLengthIsIndicatedInBytesFiveThroughEight() {
        let message = Message(type: 0, contents: someContents, compress: false)
        let bytes = message.serialize()
        let length = concatenateBytes(bytes[4], bytes[5], bytes[6], bytes[7])
        XCTAssertEqual(length, UInt32(someContents.count))
    }

    func testCompressedLengthIsIndicatedInBytesFiveThroughEight() {
        let message = Message(type: 0, contents: someContents)
        let bytes = message.serialize()
        let length = concatenateBytes(bytes[4], bytes[5], bytes[6], bytes[7])
        XCTAssertEqual(length, UInt32(compress(someContents).count))
    }

    func testUncompressedContentsIsPresentInBytesNineAndForward() {
        let message = Message(type: 0, contents: someContents, compress: false)
        let bytes = message.serialize()
        XCTAssertEqual(someContents, Array(bytes[8..<bytes.count]))
    }

    func testCompressedContentsIsPresentInBytesNineAndForward() {
        let message = Message(type: 0, contents: someContents)
        let bytes = message.serialize()
        XCTAssertEqual(compress(someContents), Array(bytes[8..<bytes.count]))
    }

    func testContentReturnsUncompressedContent() {
        let message = Message(type: 0, contents: someContents, compress: true)
        XCTAssertEqual(someContents, message.contents)
    }

    let someContents : [UInt8] = [12, 34, 56, 78]

}

class SomeMessage : Message {
    init() {
        super.init(type: 0)
    }
}
