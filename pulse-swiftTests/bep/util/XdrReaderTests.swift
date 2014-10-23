import XCTest
import pulse

class XdrReaderTests : XCTestCase {

    func testReadsStrings() {
        let xdrBytes = xdr("String1", "String2")!
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
        let uint32 : UInt32 = 0xF00FA00A
        let reader = XdrReader(xdrBytes: xdr(uint32)!)

        XCTAssertEqual(reader.readUInt32()!, uint32)
    }

    func testReadsInt32() {
        let int32 = Int32(bitPattern: 0xF00FA00A)
        let reader = XdrReader(xdrBytes: xdr(int32)!)

        XCTAssertEqual(reader.readInt32()!, int32)
    }

    func testReadsUInt64() {
        let uint64 : UInt64 = 0xF00FA00AB00BC00C
        let reader = XdrReader(xdrBytes: xdr(uint64)!)

        XCTAssertEqual(reader.readUInt64()!, uint64)
    }

    func testReadsInt64() {
        let int64 = Int64(bitPattern: 0xF00FA00AB00BC00C)
        let reader = XdrReader(xdrBytes: xdr(int64)!)

        XCTAssertEqual(reader.readInt64()!, int64)
    }

    func testReadsData() {
        let data : [UInt8] = [12, 34]
        let reader = XdrReader(xdrBytes: xdr(data)!)

        XCTAssertEqual(reader.readData()!, [12, 34])
    }

}
