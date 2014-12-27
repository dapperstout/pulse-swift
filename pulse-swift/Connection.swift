import Foundation

public class Connector {

    let identity: SecIdentity

    public init(identity: SecIdentity) {
        self.identity = identity
    }

    public func connect(host: NSString, port: UInt16, deviceId: String, onSuccess: (Connection) -> ()) {
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
}

public class Connection {

    init(socket: GCDAsyncSocket) {}

}