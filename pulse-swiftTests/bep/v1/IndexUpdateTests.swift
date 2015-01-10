import XCTest
import Pulse

class IndexUpdateTests : XCTestCase {

    func testIsType6() {
        XCTAssertEqual(message.type, UInt8(6))
    }

    let message = IndexUpdate(folder: "", files: []).encode()

}