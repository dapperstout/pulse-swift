import XCTest
import Pulse

class ConnectionTests: XCTestCase {

    var connector: Connector!
    var socket: SocketSpy!
    var tls: TLSSpy!

    let exampleHost = "1.2.3.4"
    let examplePort = UInt16(1234)
    let exampleDeviceId = "some id"
    let exampleIdentity = Identities().example()

    override func setUp() {
        socket = SocketSpy()
        tls = TLSSpy()
        connector = Connector(identity: exampleIdentity)
        connector.socket = socket
        connector.tls = tls
    }

    func testOpensConnection() {
        let expectation = expectationWithDescription("connects successfully")

        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId) {
            XCTAssertNotNil($0)
            XCTAssertEqual(self.socket.latestHost!, self.exampleHost)
            XCTAssertEqual(self.socket.latestPort!, self.examplePort)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1, nil)
    }

    func testShouldReturnNilWhenConnectionFails() {
        let expectation = expectationWithDescription("returns nil")
        socket.connectShouldSucceed = false

        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId) {
            XCTAssertNil($0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1, nil)
    }

    func testShouldUseTLSToSecureConnection() {
        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId)

        XCTAssertTrue(tls.secureSocketWasCalled)
        XCTAssertEqual(tls.latestSocket!, socket)
        XCTAssertEqual(tls.latestDeviceId!, exampleDeviceId)
        XCTAssertTrue(tls.latestIdentity! === exampleIdentity)
    }

    func testShouldReturnNilWhenSecuringSocketFails() {
        let expectation = expectationWithDescription("returns nil")
        tls.secureShouldSucceed = false

        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId) {
            XCTAssertNil($0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1, nil)
    }

    func testShouldUseSpecifiedQueueForSocketCallbacks() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        connector.queue = queue

        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId)

        XCTAssertEqual(queue, socket.latestDelegateQueue!)
    }

    func testShouldUseMainQueueByDefault() {
        XCTAssertEqual(dispatch_get_main_queue(), connector.queue)
    }
}

class TLSSpy: TLS {

    var secureShouldSucceed = true

    var secureSocketWasCalled = false

    var latestSocket: GCDAsyncSocket? = nil
    var latestDeviceId: String? = nil
    var latestIdentity: SecIdentity? = nil

    override func secureSocket(socket: GCDAsyncSocket, deviceId: String, identity: SecIdentity, onCompletion: (Bool) -> ()) {
        secureSocketWasCalled = true
        latestSocket = socket
        latestDeviceId = deviceId
        latestIdentity = identity
        onCompletion(secureShouldSucceed)
    }
}