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

}
