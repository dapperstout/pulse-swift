import XCTest
import pulse

class ConnectionTests: XCTestCase {

    var connector: Connector!
    var socket: SocketSpy!
    var gateKeeper: GateKeeperSpy!

    let exampleHost = "1.2.3.4"
    let examplePort = UInt16(1234)
    let exampleDeviceId = "some id"


    override func setUp() {
        socket = SocketSpy()
        gateKeeper = GateKeeperSpy()
        connector = Connector()
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
    }

    func testShouldReturnNilWhenSecuringSocketFails() {
        gateKeeper.secureShouldSucceed = false

        let connection = connect()

        XCTAssertNil(connection)
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

    override func secureSocket(socket: GCDAsyncSocket, deviceId: String, onSuccess: () -> () = {}) {
        secureSocketWasCalled = true
        latestSocket = socket
        latestDeviceId = deviceId
        if (secureShouldSucceed) {
            onSuccess()
        }
    }
}