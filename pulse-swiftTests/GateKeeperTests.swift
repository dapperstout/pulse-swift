import XCTest
import pulse

class GateKeeperTests: XCTestCase {

    var gateKeeper: GateKeeper!
    var socket: SocketSpy!
    var deviceId: String!
    var socketFunctions: SocketFunctionsMock!
    var readStream: CFReadStreamRef!
    var certificate: SecCertificate!
    var certificateData: NSData!

    override func setUp() {
        certificateData = readTestCertificateData()
        certificate = SecCertificateCreateWithData(nil, certificateData).takeUnretainedValue()
        readStream = createTestStream()
        socketFunctions = SocketFunctionsMock()
        deviceId = "\(DeviceId(hash: certificateData.SHA256Digest()))"
        socket = SocketSpy()
        socket.readStreamRef = Unmanaged.passUnretained(readStream)
        gateKeeper = GateKeeper()
        gateKeeper.socketFunctions = socketFunctions
    }

    func testStartsTLS() {
        gateKeeper.secureSocket(socket, deviceId: deviceId)

        XCTAssertTrue(socket.tlsStarted)
    }

    func testShouldUseAtLeastTLSv1_2() {
        let minimumVersion = getTlsSetting(GCDAsyncSocketSSLProtocolVersionMin) as NSNumber
        XCTAssertEqual(minimumVersion, NSNumber(unsignedInt: kTLSProtocol12.value))
    }

    func testShouldUseStrongCypherSuites() {
        let suites = getTlsSetting(GCDAsyncSocketSSLCipherSuites) as [NSNumber]
        let expectedSuites = [
                NSNumber(integer: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384),
                NSNumber(integer: TLS_DHE_RSA_WITH_AES_256_CBC_SHA256),
                NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384),
                NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384),
                NSNumber(integer: TLS_DHE_RSA_WITH_AES_128_GCM_SHA256),
                NSNumber(integer: TLS_DHE_RSA_WITH_AES_128_CBC_SHA256),
                NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256),
                NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256)
        ]
        XCTAssertEqual(suites, expectedSuites)
    }

    func testShouldAllowSelfSignedCertificates() {
        let validates = getTlsSetting(kCFStreamSSLValidatesCertificateChain) as Bool
        XCTAssertFalse(validates)
    }

    func testShouldCloseConnectionWhenDeviceIdDoesntMatch() {
        secureSocket("non matching id")

        XCTAssertTrue(socket.disconnected)
    }

    func testShouldNotCloseConnectionWhenDeviceIdMatches() {
        injectCorrectCertificateInSocket()

        secureSocket(deviceId)

        XCTAssertFalse(socket.disconnected)
    }

    func testCallsOnSuccessWhenDeviceIdMatches() {
        injectCorrectCertificateInSocket()

        var onSuccessCalled = false
        secureSocket(deviceId) {
            onSuccessCalled = true
        }

        XCTAssertTrue(onSuccessCalled)
    }

    func injectCorrectCertificateInSocket() {
        socketFunctions.expectedStream = readStream
        socketFunctions.expectedPropertyName = kCFStreamPropertySSLSettings
        socketFunctions.returnedStreamProperty = [String(kCFStreamSSLCertificates): [certificate]]

        socketFunctions.expectedCertificate = certificate
        socketFunctions.returnedCertificateData = Unmanaged.passRetained(certificateData)
    }

    func secureSocket(deviceId: String, onSuccess: () -> () = {}) {
        gateKeeper.secureSocket(socket, deviceId: deviceId, onSuccess)
        socket.latestDelegate!.socketDidSecure!(socket)
    }

    func readTestCertificateData() -> NSData {
        let bundle = NSBundle(forClass: self.dynamicType)
        return NSData(contentsOfFile: bundle.pathForResource("cert", ofType: "der")!)!
    }

    func createTestStream() -> CFReadStreamRef {
        return CFReadStreamCreateWithBytesNoCopy(kCFAllocatorDefault, [], 0, kCFAllocatorNull)!
    }

    func getTlsSetting(key: NSObject) -> AnyObject {
        gateKeeper.secureSocket(socket, deviceId: deviceId)
        let tlsSettings = socket.latestTlsSettings!
        return tlsSettings[key]!
    }
}
