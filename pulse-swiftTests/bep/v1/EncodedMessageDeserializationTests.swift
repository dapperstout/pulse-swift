import XCTest
import Pulse

class EncodedMessageDeserializationTests: XCTestCase {

    func testShouldParseMessagesWithVersionZero() {
        let message = EncodedMessage.deserialize(createHeader(version: 0))

        XCTAssertNotNil(message)
    }

    func testShouldFailToParseMessageWithVersionOtherThanZero() {
        let message = EncodedMessage.deserialize(createHeader(version: 1))

        XCTAssertNil(message)
    }

    func testShouldFailToParseMessageWithLessThanFourBytes() {
        let message = EncodedMessage.deserialize([0, 0, 0])

        XCTAssertNil(message)
    }

    func testShouldParseMessageId() {
        let bytes = EncodedMessage(id: 42, type: 0).serialize()

        let message = EncodedMessage.deserialize(bytes)!

        XCTAssertEqual(UInt16(42), message.id)
    }

    func testShouldParseType() {
        let bytes = EncodedMessage(type: 42).serialize()

        let message = EncodedMessage.deserialize(bytes)!

        XCTAssertEqual(UInt8(42), message.type)
    }

    func testShouldParseContents() {
        let contents: [UInt8] = [1, 2, 3, 4]
        let bytes = EncodedMessage(type: 0, contents: contents, compress: false).serialize()

        let message = EncodedMessage.deserialize(bytes)!

        XCTAssertEqual(contents, message.contents)
    }

    func testShouldParseCompressedContents() {
        let contents: [UInt8] = [1, 2, 3, 4]
        let bytes = EncodedMessage(type: 0, contents: contents, compress: true).serialize()

        let message = EncodedMessage.deserialize(bytes)!

        XCTAssertEqual(contents, message.contents)
    }

    func testShouldFailToParseContentsOfInsufficientLength() {
        var bytes = EncodedMessage(type: 0, contents: [1,2,3]).serialize()
        bytes.removeLast()

        XCTAssertNil(EncodedMessage.deserialize(bytes))
    }

    func testShouldFailToParseContentsWithExtraneousBytes() {
        var bytes = EncodedMessage(type: 0, contents: [1,2,3]).serialize()
        bytes.append(42)

        XCTAssertNil(EncodedMessage.deserialize(bytes))
    }

    func createHeader(#version: UInt8) -> [UInt8] {
        var header: [UInt8] = []
        header.append(concatenateNibbles(version, 0))
        header.append(0)
        header.append(0)
        header.append(0)
        header.append(0)
        header.append(0)
        header.append(0)
        header.append(0)
        return header
    }
}