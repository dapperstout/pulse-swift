import XCTest
import pulse

class ConnectionTests: XCTestCase {

    var connector: Connector!
    var socket: SocketSpy!
    var gateKeeper: GateKeeperSpy!

    let exampleHost = "1.2.3.4"
    let examplePort = UInt16(1234)
    let exampleDeviceId = "some id"
    let exampleIdentity = Identities().example()

    override func setUp() {
        socket = SocketSpy()
        gateKeeper = GateKeeperSpy()
        connector = Connector(identity: exampleIdentity)
        connector.socket = socket
        connector.gateKeeper = gateKeeper
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

    func testShouldUseGateKeeperToSecureConnection() {
        let connection = connect();

        XCTAssertTrue(gateKeeper.secureSocketWasCalled)
        XCTAssertEqual(gateKeeper.latestSocket!, socket)
        XCTAssertEqual(gateKeeper.latestDeviceId!, exampleDeviceId)
        XCTAssertTrue(gateKeeper.latestIdentity! === exampleIdentity)
    }

    func testShouldReturnNilWhenSecuringSocketFails() {
        gateKeeper.secureShouldSucceed = false

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

class GateKeeperSpy: GateKeeper {

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