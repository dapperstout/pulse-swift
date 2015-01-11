import XCTest
import Pulse

class ResponseTests : XCTestCase {

    func testIsType3() {
        XCTAssertEqual(message.type, UInt8(3))
    }

    func testHasXdrEncodedData() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readData()!, response.data)
    }

    func testHasSameMessageIdAsRequest() {
        let request = Request.example
        let response = Response(request: request, data: [])
        XCTAssertEqual(response.encode().id, request.id)
    }

    let response = Response.example
    let message = Response.example.encode()
}

extension Response {

    class var example: Response {
        let someRequest = Request.example
        let someData : [UInt8] = [12, 34]
        return Response(request: someRequest, data: someData)
    }

}

