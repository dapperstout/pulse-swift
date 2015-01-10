import XCTest
import Pulse

class ResponseTests : XCTestCase {

    let message = Response(request: someRequest, data: someData).encode()

    func testIsType3() {
        XCTAssertEqual(message.type, UInt8(2))
    }

    func testHasXdrEncodedData() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readData()!, someData)
    }

    func testHasSameMessageIdAsRequest() {
        XCTAssertEqual(message.id, someRequest.id)
    }

}

let someRequest = Request(repository: "", name: "", offset: 0, size: 0)
let someData : [UInt8] = [12, 34]