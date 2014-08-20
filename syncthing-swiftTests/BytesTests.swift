import XCTest
import syncthing

class BytesTest : XCTestCase {

    func testDecompositionOfByteIntoBits() {
        let eightBits = bits(0b10101010)
        XCTAssertEqual(eightBits, [true, false, true, false, true, false, true, false])
    }

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

    func testDecompositionOfIntIntoBytes() {
        let (b0, b1, b2, b3) = bytes(0xF00FA00A)
        XCTAssertEqual(b0, 0xF0)
        XCTAssertEqual(b1, 0x0F)
        XCTAssertEqual(b2, 0xA0)
        XCTAssertEqual(b3, 0x0A)
    }

    func testConcatenationOfBitsIntoByte() {
        let eightBits = [true, false, true, false, true, false, true, false]
        XCTAssertEqual(concatenateBits(eightBits), 0b10101010)
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

    func testConcatenationOfBytesIntoInt() {
        let b0 = UInt8(0xF0)
        let b1 = UInt8(0x0F)
        let b2 = UInt8(0xA0)
        let b3 = UInt8(0x0A)
        XCTAssertEqual(concatenateBytes(b0, b1, b2, b3), 0xF00FA00A)
    }

}
