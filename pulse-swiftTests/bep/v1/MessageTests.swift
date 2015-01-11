import XCTest
import Pulse

class MessageTests: XCTestCase {

    func testCanDecodeClusterConfig() {
        let clusterConfig = ClusterConfig.example
        let encodedMessage = clusterConfig.encode()
        let decodedMessage = Message.decode(encodedMessage)!
        XCTAssertEqual(decodedMessage as ClusterConfig, clusterConfig)
    }

}