import XCTest
import Pulse

class MessageParserTests: XCTestCase {

    func testShouldParseMessagesWithVersionZero() {
        let message = Message.deserialize(createHeader(version: 0))

        XCTAssertNotNil(message)
    }

    func testShouldFailToParseMessageWithVersionOtherThanZero() {
        let message = Message.deserialize(createHeader(version: 1))

        XCTAssertNil(message)
    }

    func testShouldFailToParseMessageWithLessThanFourBytes() {
        let message = Message.deserialize([0, 0, 0])

        XCTAssertNil(message)
    }

    func testShouldParseMessageId() {
        let bytes = Message(id: 42, type: 0).serialize()

        let message = Message.deserialize(bytes)!

        XCTAssertEqual(UInt16(42), message.id)
    }

    func testShouldParseType() {
        let bytes = Message(type: 42).serialize()

        let message = Message.deserialize(bytes)!

        XCTAssertEqual(UInt8(42), message.type)
    }

    func testShouldParseContents() {
        let contents: [UInt8] = [1, 2, 3, 4]
        let bytes = Message(type: 0, contents: contents, compress: false).serialize()

        let message = Message.deserialize(bytes)!

        XCTAssertEqual(contents, message.contents)
    }

    func testShouldParseCompressedContents() {
        let contents: [UInt8] = [1, 2, 3, 4]
        let bytes = Message(type: 0, contents: contents, compress: true).serialize()

        let message = Message.deserialize(bytes)!

        XCTAssertEqual(contents, message.contents)
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