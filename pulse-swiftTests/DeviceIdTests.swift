import XCTest
import pulse

class DeviceIdTests: XCTestCase {

    var certificateHash : [UInt8]!
    var deviceId : DeviceId!

    override func setUp() {
        certificateHash = [UInt8](count: 256, repeatedValue: 42)
        deviceId = DeviceId(hash: certificateHash)
    }

    func testCanBeCreatedFromHashOfSize256() {
        XCTAssertNotNil(deviceId)
    }

    func testDoesNotAcceptHashOfDifferentSize() {
        let wrongHash = [UInt8](count: 242, repeatedValue: 42)
        XCTAssertNil(DeviceId(hash: wrongHash))
    }

    func testCanBeConvertedToBase32String() {
        XCTAssertTrue("\(deviceId)".hasPrefix("FIVCUKR"))
    }

    func testBase32StringContainsOnlyBase32CharactersAndHyphens() {
        for char in "\(deviceId)" {
            XCTAssertTrue(contains("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567-", char))
        }
    }

    func testBase32StringConsistsOfEightGroups() {
        let groups = "\(deviceId)".componentsSeparatedByString("-")
        XCTAssertEqual(8, groups.count);
    }
}