import XCTest
import Pulse

class XdrTests : XCTestCase {

    let someString = "Some String"
    let someData : [UInt8] = [12, 34]
    let someUInt64 : UInt64 = 42
    let someUInt32 : UInt32 = 3
    let someInt64 : Int64 = -42
    let someInt32 : Int32 = -3

    func testEncodesIntermingledTypes() {
        let xdrBytes = xdr(
            someString, someData,
            someUInt64, someUInt32,
            someInt64, someInt32)!
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readString()!, someString)
        XCTAssertEqual(reader.readData()!, someData)
        XCTAssertEqual(reader.readUInt64()!, someUInt64)
        XCTAssertEqual(reader.readUInt32()!, someUInt32)
        XCTAssertEqual(reader.readInt64()!, someInt64)
        XCTAssertEqual(reader.readInt32()!, someInt32)
    }

}
