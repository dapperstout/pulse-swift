import Pulse
import XCTest

class ConnectionIntegrationTests: XCTestCase {

    var connector: Connector!
    let exampleDeviceId = "3XGRA4E-SSXHXPF-UA6V3L2-6IOJHHZ-5AOGWGJ-VOHWDPM-TTYWREL-Z56XNA7"
    let exampleIdentity = Identities().example()
    let host = "127.0.0.1"
    let port:UInt16 = 59296 // TODO This port is now hard-coded also in the pre-test and post-test scripts
    var connection: Connection? = nil

    override func setUp() {
        connector = Connector(identity: exampleIdentity)
    }
    
    func testOpensConnection() {
        let expectation = self.expectationWithDescription("connection succeeds")

        connector.connect(host, port: port, deviceId: exampleDeviceId) {
            XCTAssertNotNil($0)
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(5, nil)
    }
}
