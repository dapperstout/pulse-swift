public class GateKeeper {

    var session: GateKeeperSession!
    
    public init() {}

    public func secureSocket(socket: GCDAsyncSocket, deviceId: String, identity: SecIdentity, onSuccess: () -> () = {}) {
        session = GateKeeperSession(socket, deviceId, identity, onSuccess)
        session.socketFunctions = socketFunctions
        session.secure()
    }

    public var socketFunctions = SocketFunctions()
}

class GateKeeperSession: NSObject, GCDAsyncSocketDelegate {
    let deviceId: String
    let socket: GCDAsyncSocket
    let identity: SecIdentity
    let onSuccess: () -> ()

    init(_ socket: GCDAsyncSocket, _ deviceId: String, _ identity: SecIdentity, _ onSuccess: () -> ()) {
        self.socket = socket
        self.deviceId = deviceId
        self.identity = identity
        self.onSuccess = onSuccess
    }

    func secure() {
        socket.setDelegate(self)
        socket.startTLS([
                GCDAsyncSocketSSLProtocolVersionMin: NSNumber(unsignedInt: kTLSProtocol12.value),
                GCDAsyncSocketSSLCipherSuites: acceptableCipherSuites,
                kCFStreamSSLValidatesCertificateChain: false,
                kCFStreamSSLCertificates: [identity]
        ])
    }

    func socketDidSecure(socket: GCDAsyncSocket) {
        socket.performBlock {
            self.checkCertificate(socket)
        }
    }

    func checkCertificate(socket: GCDAsyncSocket) {
        var success = false
        if let certificateData = extractCertificateData(socket) {
            if "\(DeviceId(hash: certificateData.SHA256Digest()))" == self.deviceId {
                success = true
            }
        }
        if (success) {
            onSuccess()
        } else {
            socket.disconnect()
        }
    }

    func extractCertificateData(socket: GCDAsyncSocket) -> NSData? {
        let stream = socket.readStream().takeRetainedValue()
        let s = self.socketFunctions
        if let sslSettings = s.CFReadStreamCopyProperty(stream, kCFStreamPropertySSLSettings) as? [String:AnyObject] {
            if let certificates = sslSettings[kCFStreamSSLCertificates] as? [AnyObject] {
                let identity = certificates[0] as SecIdentity
                return identity.certificate.data
            }
        }
        return nil
    }

    let acceptableCipherSuites = [
            NSNumber(integer: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(integer: TLS_DHE_RSA_WITH_AES_256_CBC_SHA256),
            NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384),
            NSNumber(integer: TLS_DHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(integer: TLS_DHE_RSA_WITH_AES_128_CBC_SHA256),
            NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(integer: TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256)
    ];

    var socketFunctions: SocketFunctions = SocketFunctions()
}