import XCTest
import pulse

class ResponseTests : XCTestCase {

    let response = Response(request: someRequest, data: someData)

    func testIsType3() {
        XCTAssertEqual(response.type, UInt8(2))
    }

    func testHasXdrEncodedData() {
        let reader = XdrReader(xdrBytes: response.contents)
        XCTAssertEqual(reader.readData()!, someData)
    }

    func testHasSameMessageIdAsRequest() {
        XCTAssertEqual(response.id, someRequest.id)
    }

}

let someRequest = Request(repository: "", name: "", offset: 0, size: 0)
let someData : [UInt8] = [12, 34]