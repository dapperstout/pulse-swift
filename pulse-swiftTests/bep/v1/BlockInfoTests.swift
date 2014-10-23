import XCTest
import pulse

class BlockInfoTests : XCTestCase {

    func testXdrEncodesItsSize() {
        let reader = xdrReader(someBlockInfo)
        XCTAssertEqual(reader.readUInt32()!, someBlockInfo.size)
    }

    func testXdrEncodesItsHash() {
        let reader = xdrReader(someBlockInfo)
        reader.readUInt32()
        XCTAssertEqual(reader.readData()!, someBlockInfo.hash)
    }

    func testCanBeReadFromXdr() {
        let reader = xdrReader(someBlockInfo)
        let blockInfo = reader.read(BlockInfo)!
        XCTAssertEqual(blockInfo, someBlockInfo)
    }

    func xdrReader(blockInfo: BlockInfo) -> XdrReader {
        let xdrBytes = XdrWriter().write(blockInfo).xdrBytes
        return XdrReader(xdrBytes: xdrBytes)
    }

    let someBlockInfo = BlockInfo(size: 42, hash: [12, 34])
}