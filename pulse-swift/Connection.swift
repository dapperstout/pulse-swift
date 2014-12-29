import Foundation

public class Connector : NSObject {

    let identity: SecIdentity

    public init(identity: SecIdentity) {
        self.identity = identity
    }

    public func connect(host: NSString, port: UInt16, deviceId: String, onSuccess: (Connection) -> ()) {
        socket.setDelegateQueue(queue)
        socket.synchronouslySetDelegate(self) // TODO: don't actually need delegate here, but without it, connectToHost doesn't work...
        if socket.connectToHost(host, onPort: port, error: nil) {
            secure(socket, deviceId: deviceId, onSuccess)
        }
    }

    func secure(socket: GCDAsyncSocket, deviceId: String, onSuccess: (Connection) -> ()) {
        gateKeeper.secureSocket(socket, deviceId: deviceId, identity: identity) {
            let connection = Connection(socket: self.socket)
            onSuccess(connection)
        }
    }

    public var socket: GCDAsyncSocket = GCDAsyncSocket()
    public var gateKeeper: GateKeeper = GateKeeper()
    public var queue = dispatch_get_main_queue()
}

public class Connection {

    init(socket: GCDAsyncSocket) {}

}