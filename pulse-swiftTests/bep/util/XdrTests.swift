import XCTest
import pulse

class XdrTests : XCTestCase {

    let someString = "Some String"
    let someData : [UInt8] = [12, 34]
    let someUInt64 : UInt64 = 42
    let someUInt32 : UInt32 = 3

    func testEncodesIntermingledTypes() {
        let xdrBytes = xdr(someString, someData, someUInt64, someUInt32)!
        let reader = XdrReader(xdrBytes: xdrBytes)

        XCTAssertEqual(reader.readString()!, someString)
        XCTAssertEqual(reader.readData()!, someData)
        XCTAssertEqual(reader.readUInt64()!, someUInt64)
        XCTAssertEqual(reader.readUInt32()!, someUInt32)
    }

}



