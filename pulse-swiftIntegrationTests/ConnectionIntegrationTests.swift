import pulse
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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOpensConnection() {
        connect();
        wait(5);
        XCTAssertNotNil(self.connection)
    }
    
    func wait(delay:NSTimeInterval) {
        let until = NSDate().dateByAddingTimeInterval(delay);
        NSRunLoop.currentRunLoop().runUntilDate(until);
    }
    
    func connect() {
        connector.connect(host, port: port, deviceId: exampleDeviceId) {
            self.connection = $0
        }
    }

}
