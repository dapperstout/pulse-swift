import Foundation

public class Connector : NSObject {

    let identity: SecIdentity

    public init(identity: SecIdentity) {
        self.identity = identity
    }

    public func connect(host: NSString, port: UInt16, deviceId: String, onCompletion: (Connection?) -> () = {(connection: Connection?) in }) {
        socket.setDelegateQueue(queue)
        socket.synchronouslySetDelegate(self) // TODO: don't actually need delegate here, but without it, connectToHost doesn't work...
        if socket.connectToHost(host, onPort: port, error: nil) {
            secure(socket, deviceId: deviceId, onCompletion)
        } else {
            onCompletion(nil)
        }
    }

    func secure(socket: GCDAsyncSocket, deviceId: String, onCompletion: (Connection?) -> ()) {
        tls.secureSocket(socket, deviceId: deviceId, identity: identity) { (Bool success) in
            if success {
                onCompletion(Connection(socket: self.socket))
            } else {
                onCompletion(nil)
            }
        }
    }

    public var socket: GCDAsyncSocket = GCDAsyncSocket()
    public var tls: TLS = TLS()
    public var queue = dispatch_get_main_queue()
}

public class Connection {

    init(socket: GCDAsyncSocket) {}

}