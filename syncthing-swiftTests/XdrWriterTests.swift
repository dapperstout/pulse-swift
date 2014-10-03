import XCTest
import syncthing

class XdrWriterTests : XCTestCase {

    let writer = XdrWriter()
    let someString = "String with interesting unicode character \u{221E}"

    func testWritesStringLength() {
        writer.writeString(someString)
        let xdrStringLength = extractXdrDataLength(writer.xdrBytes)
        XCTAssertEqual(xdrStringLength, UInt32(someString.utf8Bytes.count))
    }

    func testWritesString() {
        writer.writeString(someString)
        let xdrStringLength = extractXdrDataLength(writer.xdrBytes)
        let xdrStringBytes = writer.xdrBytes[4..<Int(4+xdrStringLength)]
        XCTAssertEqual(String.fromUtf8Bytes(xdrStringBytes)!, someString)
    }

    func testPadsStringToFourByteBoundary() {
        writer.writeString(someString)
        XCTAssertEqual(writer.xdrBytes.count % 4, 0)
    }

    func extractXdrDataLength(bytes : [UInt8]) -> UInt32 {
        return concatenateBytes(bytes[0], bytes[1], bytes[2], bytes[3])
    }

}