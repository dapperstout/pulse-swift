import XCTest
import pulse

class XdrWriterTests : XCTestCase {

    let writer = XdrWriter()

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

    func testWritesDataLength() {
        writer.writeData(someData)
        let dataLength = extractXdrDataLength(writer.xdrBytes)
        XCTAssertEqual(Int(dataLength), someData.count)
    }

    func testWritesData() {
        writer.writeData(someData)
        let dataLength = extractXdrDataLength(writer.xdrBytes)
        let data = [UInt8](writer.xdrBytes[4..<Int(4+dataLength)])
        XCTAssertEqual(data, someData)

    }

    func extractXdrDataLength(bytes : [UInt8]) -> UInt32 {
        return concatenateBytes(bytes[0], bytes[1], bytes[2], bytes[3])
    }

    func testWritesUInt32() {
        let uint32 : UInt32 = 0xF00FA00A
        writer.writeUInt32(uint32)
        XCTAssertEqual(writer.xdrBytes, bytes(uint32))
    }

    func testWritesUInt64() {
        let uint64 : UInt64 = 0xF00FA00AB00BC00C
        writer.writeUInt64(uint64)
        XCTAssertEqual(writer.xdrBytes, bytes(uint64))
    }

    let someString = "String with interesting unicode character \u{221E}"
    let someData : [UInt8] = [12, 34]

}