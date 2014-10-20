import XCTest
import pulse

class OptionsTest: XCTestCase {

    func testXdrEncodesNumberOfOptions() {
        let reader = xdrReader(Options(someOptions))
        XCTAssertEqual(reader.readUInt32()!, UInt32(someOptions.count))
    }

    func testXdrEncodesKeyAndValuePairs() {
        let reader = xdrReader(Options(someOptions))
        reader.readUInt32()
        for (key, value) in someOptions {
            XCTAssertEqual(reader.readString()!, key)
            XCTAssertEqual(reader.readString()!, value)
        }
    }

    func testCanBeReadFromXdr() {
        let writtenOptions = Options(someOptions)
        let reader = xdrReader(writtenOptions)
        let readOptions = reader.read(Options)!
        XCTAssertEqual(readOptions, writtenOptions)
    }

    func xdrReader(options: Options) -> XdrReader {
        let xdrBytes = XdrWriter().write(options).xdrBytes
        return XdrReader(xdrBytes: xdrBytes)
    }

    let someOptions = [
        "Key 1": "Value 1",
        "Key 2": "Value 2"
    ]
}