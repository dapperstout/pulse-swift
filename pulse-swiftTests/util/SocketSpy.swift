import Pulse

class SocketSpy: GCDAsyncSocket {

    var readStreamRef: Unmanaged<CFReadStreamRef>? = nil
    var connectShouldSucceed = true
    var startTLSShouldSucceed = true

    var tlsStarted = false
    var disconnected = false

    var latestHost: String?
    var latestPort: UInt16?
    var latestTlsSettings: [NSObject:AnyObject]?
    var latestDelegate: GCDAsyncSocketDelegate?
    var latestDelegateQueue: dispatch_queue_t?

    override func setDelegate(delegate: AnyObject?) {
        latestDelegate = delegate as? GCDAsyncSocketDelegate
    }

    override func setDelegateQueue(queue: dispatch_queue_t) {
        latestDelegateQueue = queue
    }

    override func connectToHost(host: String!, onPort port: UInt16, error errPtr: NSErrorPointer) -> Bool {
        latestHost = host
        latestPort = port
        return connectShouldSucceed
    }

    override func startTLS(tlsSettings: [NSObject:AnyObject]!) {
        latestTlsSettings = tlsSettings
        if startTLSShouldSucceed {
            latestDelegate?.socketDidSecure?(self)
            tlsStarted = true;
        } else {
            latestDelegate?.socketDidDisconnect?(self, withError:nil)
        }
    }

    override func disconnect() {
        disconnected = true;
    }

    override func readStream() -> Unmanaged<CFReadStreamRef>! {
        return readStreamRef
    }
}