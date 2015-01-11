import XCTest
import Pulse

class MessageTests: XCTestCase {

    func testCanDecodeClusterConfig() {
        let clusterConfig = ClusterConfig.example
        let encodedMessage = clusterConfig.encode()
        let decodedMessage = Message.decode(encodedMessage)!
        XCTAssertEqual(decodedMessage as ClusterConfig, clusterConfig)
    }

    func testCanDecodeIndex() {
        let index = Index.exampleIndex
        let encodedMessage = index.encode()
        let decodedMessage = Message.decode(encodedMessage)!
        XCTAssertEqual(decodedMessage as Index, index)
    }

    func testCanDecodeIndexUpdate() {
        let update = IndexUpdate.exampleIndexUpdate
        let encodedMessage = update.encode()
        let decodedMessage = Message.decode(encodedMessage)!
        XCTAssertEqual(decodedMessage as IndexUpdate, update)
    }

    func testCanDecodeRequest() {
        let request = Request.example
        let encodedMessage = request.encode()
        let decodedMessage = Message.decode(encodedMessage)!
        XCTAssertEqual(decodedMessage as Request, request)
    }

}