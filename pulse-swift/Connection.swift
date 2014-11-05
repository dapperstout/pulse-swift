import Foundation

public class Connector {

    let socket: GCDAsyncSocket

    public init(socket: GCDAsyncSocket? = nil) {
        self.socket = socket != nil ? socket : GCDAsyncSocket()
    }

    public func connect(host: NSString, port: UInt16) -> Connection? {
        if socket.connectToHost(host, onPort: port, error: nil) {
            return Connection(socket: socket)
        }
        return nil
    }

    public class Connection {

        init(socket: GCDAsyncSocket) {
            socket.startTLS([
                GCDAsyncSocketSSLProtocolVersionMin: NSNumber(enumValue: kTLSProtocol12),
                GCDAsyncSocketSSLCipherSuites: acceptableCipherSuites,
                kCFStreamSSLValidatesCertificateChain : false
            ])
        }

        let acceptableCipherSuites = [
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_256_CBC_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(enumValue: TLS_DHE_RSA_WITH_AES_128_CBC_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256),
            NSNumber(enumValue: TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256)
        ];

    }
}
