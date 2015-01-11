import XCTest
import Pulse

class IndexUpdateTests : XCTestCase {

    func testIsType6() {
        XCTAssertEqual(message.type, UInt8(6))
    }

    let message = IndexUpdate.exampleIndexUpdate.encode()

}

extension IndexUpdate {

    public class var exampleIndexUpdate: IndexUpdate {
        return IndexUpdate(folder: "", files: [])
    }

}