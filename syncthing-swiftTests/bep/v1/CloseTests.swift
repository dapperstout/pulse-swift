import XCTest
import syncthing

class CloseTests : XCTestCase {

    let close = Close(message: "some reason")

    func testHasType7() {
        XCTAssertEqual(close.type, 7)
    }

}
