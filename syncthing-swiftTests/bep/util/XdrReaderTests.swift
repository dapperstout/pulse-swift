import XCTest
import syncthing

class XdrReaderTests : XCTestCase {

    func testReadsStrings() {
        let xdrBytes = XdrWriter().writeString("String1").writeString("String2").xdrBytes
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readString()!, "String1")
        XCTAssertEqual(reader.readString()!, "String2")
    }

    func testReturnsNilWhenStringLengthCouldNotBeRead() {
        let reader = XdrReader(xdrBytes: [0, 0, 0])

        XCTAssertNil(reader.readString())
    }

    func testReturnsNilWhenStringCouldNotBeRead() {
        let reader = XdrReader(xdrBytes: [0, 0, 0, 2, 32])

        XCTAssertNil(reader.readString())
    }

    func testReadsUInt32() {
        let xdrBytes = XdrWriter().writeUInt32(0xF00FA00A).xdrBytes
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readUInt32()!, 0xF00FA00A)
    }

    func testReadsUInt64() {
        let xdrBytes = XdrWriter().writeUInt64(0xF00FA00AB00BC00C).xdrBytes
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readUInt64()!, 0xF00FA00AB00BC00C)
    }

    func testReadsData() {
        let xdrBytes = XdrWriter().writeData([12, 34]).xdrBytes
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readData()!, [12, 34])
    }

}
