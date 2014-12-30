import XCTest
import Pulse

class LZ4CompressionTests : XCTestCase {

    func testCompressedOutputStartsWithUncompressedSize() {
        let compressed = compress(someData)
        XCTAssertEqual(
            Int(concatenateBytes(compressed[0], compressed[1], compressed[2], compressed[3])),
            someData.count
        )
    }

    func testCanDecompressCompressedData() {
        let compressed = compress(someData)
        XCTAssertEqual(decompress(compressed)!, someData)
    }

    func testCanDecompressCompressedEmptyData() {
        let compressed = compress([])
        XCTAssertEqual(decompress(compressed)!, [])
    }

    func testShouldNotDecompressInvalidData() {
        let compressed : [UInt8] = [0, 0, 0, 1, 12, 34, 56, 78]
        XCTAssertTrue(decompress(compressed) == nil)
    }

    func testShouldNotDecompressInvalidLength() {
        let compressed : [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0]
        XCTAssertTrue(decompress(compressed) == nil)
    }

    let someData : [UInt8] = [12, 34, 56, 78]
}