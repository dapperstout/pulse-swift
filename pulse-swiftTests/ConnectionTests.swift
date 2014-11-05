import XCTest
import pulse

class ConnectionTests : XCTestCase {

    var connector: Connector!
    var socket: SocketSpy!

    override func setUp() {
        socket = SocketSpy()
        connector = Connector(socket: socket!)
    }

    func testOpensConnection() {
        let connection = connector.connect("1.2.3.4", port: 1234)

        XCTAssertNotNil(connection)
        XCTAssertEqual(socket.latestHost!, "1.2.3.4")
        XCTAssertEqual(socket.latestPort!, UInt16(1234))
    }

    func testReturnsNilWhenConnectionFails() {
        socket.connectShouldSucceed = false

        let connection = connector.connect("1.2.3.4", port: 1234)

        XCTAssertNil(connection)
    }

    func testStartsTLS() {
        let connection = connector.connect("1.2.3.4", port: 1234)

        XCTAssertTrue(socket.tlsStarted)
    }

    func testShouldUseAtLeastTLSv1_2() {
        let minimumVersion = getTlsSetting(GCDAsyncSocketSSLProtocolVersionMin) as NSNumber
        XCTAssertEqual(minimumVersion, NSNumber(enumValue: kTLSProtocol12))
    }

    func testShouldUseStrongCypherSuites() {
        let suites = getTlsSetting(GCDAsyncSocketSSLCipherSuites) as [NSNumber]
        let expectedSuites = [
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_256_CBC_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_128_CBC_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256)
        ]
        XCTAssertEqual(suites, expectedSuites)
    }

    func testShouldAllowSelfSignedCertificates() {
        let validates = getTlsSetting(kCFStreamSSLValidatesCertificateChain) as Bool
        XCTAssertFalse(validates)
    }

    func getTlsSetting(key: NSObject) -> AnyObject {
        let connection = connector.connect("1.2.3.4", port: 1234)
        let tlsSettings = socket.latestTlsSettings!
        return tlsSettings[key]!
    }

    class SocketSpy : GCDAsyncSocket {

        var latestHost: String?
        var latestPort: UInt16?
        var latestTlsSettings: [NSObject : AnyObject]?

        var connectShouldSucceed = true
        var tlsStarted = false

        override func connectToHost(host: String!, onPort port: UInt16, error errPtr: NSErrorPointer) -> Bool {
            latestHost = host
            latestPort = port
            return connectShouldSucceed
        }

        override func startTLS(tlsSettings: [NSObject : AnyObject]!) {
            tlsStarted = true;
            latestTlsSettings = tlsSettings
        }
    }
}