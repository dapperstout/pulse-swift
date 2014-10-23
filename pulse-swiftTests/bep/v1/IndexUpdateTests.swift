import XCTest
import pulse

class IndexUpdateTests : XCTestCase {

    func testIsType6() {
        XCTAssertEqual(IndexUpdate(folder: "", files: []).type, 6)
    }

}