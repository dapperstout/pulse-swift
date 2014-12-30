import XCTest
import pulse

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
        let connection = connect();

        XCTAssertNotNil(connection)
        XCTAssertEqual(socket.latestHost!, exampleHost)
        XCTAssertEqual(socket.latestPort!, examplePort)
    }

    func testShouldReturnNilWhenConnectionFails() {
        socket.connectShouldSucceed = false

        let connection = connect();

        XCTAssertNil(connection)
    }

    func testShouldUseTLSToSecureConnection() {
        let connection = connect();

        XCTAssertTrue(tls.secureSocketWasCalled)
        XCTAssertEqual(tls.latestSocket!, socket)
        XCTAssertEqual(tls.latestDeviceId!, exampleDeviceId)
        XCTAssertTrue(tls.latestIdentity! === exampleIdentity)
    }

    func testShouldReturnNilWhenSecuringSocketFails() {
        tls.secureShouldSucceed = false

        let connection = connect()

        XCTAssertNil(connection)
    }

    func testShouldUseSpecifiedQueueForSocketCallbacks() {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        connector.queue = queue

        connect()

        XCTAssertEqual(queue, socket.latestDelegateQueue!)
    }

    func testShouldUseMainQueueByDefault() {
        XCTAssertEqual(dispatch_get_main_queue(), connector.queue)
    }

    func connect() -> Connection? {
        var connection: Connection? = nil
        connector.connect(exampleHost, port: examplePort, deviceId: exampleDeviceId) {
            connection = $0
        }
        return connection
    }
}

class TLSSpy: TLS {

    var secureShouldSucceed = true

    var secureSocketWasCalled = false

    var latestSocket: GCDAsyncSocket? = nil
    var latestDeviceId: String? = nil
    var latestIdentity: SecIdentity? = nil

    override func secureSocket(socket: GCDAsyncSocket, deviceId: String, identity: SecIdentity, onSuccess: () -> () = {}) {
        secureSocketWasCalled = true
        latestSocket = socket
        latestDeviceId = deviceId
        latestIdentity = identity
        if (secureShouldSucceed) {
            onSuccess()
        }
    }
}