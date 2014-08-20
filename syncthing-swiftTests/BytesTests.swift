import XCTest
import syncthing

class BytesTest : XCTestCase {

    func testDecompositionOfByteIntoNibbles() {
        let (left, right) = nibbles(0b1010_0101);
        XCTAssertEqual(left, 0b1010);
        XCTAssertEqual(right, 0b0101);
    }

}
