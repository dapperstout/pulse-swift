import XCTest
import syncthing

class BytesTest : XCTestCase {

    func testDecompositionOfByteIntoNibbles() {
        let (left, right) = nibbles(0b1010_0101);
        XCTAssertEqual(left, 0b1010);
        XCTAssertEqual(right, 0b0101);
    }

    func testDecompositionOfShortIntoBytes() {
        let (left, right) = bytes(0b10101010_01010101)
        XCTAssertEqual(left, 0b10101010)
        XCTAssertEqual(right, 0b01010101)
    }

    func testConcatenationOfNibblesIntoByte() {
        let left = UInt8(0b1010)
        let right = UInt8(0b0101)
        XCTAssertEqual(concatenateNibbles(left, right), UInt8(0b1010_0101))
    }

    func testConcatenationOfBytesIntoShort() {
        let left = UInt8(0b10101010)
        let right = UInt8(0b01010101)
        XCTAssertEqual(concatenateBytes(left, right), 0b10101010_01010101)
    }

}
