import XCTest
import syncthing

class BytesTest : XCTestCase {

    func testDecompositionOfByteIntoBits() {
        let eightBits = bits(0b10101010)
        XCTAssertEqual(eightBits, [true, false, true, false, true, false, true, false])
    }

    func testDecompositionOfByteIntoNibbles() {
        XCTAssertEqual(nibbles(0b1010_0101), [0b1010, 0b0101]);
    }

    func testDecompositionOfShortIntoBytes() {
        XCTAssertEqual(bytes(UInt16(0b10101010_01010101)), [0b10101010, 0b01010101])
    }

    func testDecompositionOfIntIntoBytes() {
        XCTAssertEqual(bytes(UInt32(0xF00FA00A)), [0xF0, 0x0F, 0xA0, 0x0A])
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

    func testUnsignedByte() {
        let signed = Int8(bitPattern: 0xFF)
        XCTAssertEqual(unsigned(signed), 0xFF)
    }

    func testUnsignedArray() {
        let signed = [Int8(bitPattern: 0xF0), Int8(bitPattern: 0x0F)]
        XCTAssertEqual(unsigned(signed), [0xF0, 0x0F])
    }

    func testSignedByte() {
        let unsigned = UInt8(0xFF)
        XCTAssertEqual(signed(unsigned), Int8(bitPattern: 0xFF))
    }

    func testSignedArray() {
        let unsigned : [UInt8] = [0xF0, 0x0F]
        XCTAssertEqual(signed(unsigned), [signed(0xF0), signed(0x0F)])
    }

}
