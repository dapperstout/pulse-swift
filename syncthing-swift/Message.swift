import Foundation

public class Message
{
    let version : UInt8 = 0
    let id = getNextMessageId()
    let type : UInt8

    public init(type : UInt8) {
        self.type = type
    }

    public func serialize() -> [UInt8] {
        var result : [UInt8] = []
        let idBytes = bytes(id)
        result.append(concatenateNibbles(version, idBytes.0))
        result.append(idBytes.1)
        result.append(type)
        return result;
    }
}

private func getNextMessageId() -> UInt16 {
    var result = UInt16()
    dispatch_sync(nextMessageIdLock, {
        result = nextMessageId
        nextMessageId = (nextMessageId + 1) % 4096
    })
    return result
}

private var nextMessageId : UInt16 = 0
private let nextMessageIdLock = dispatch_queue_create("syncthing.nextMessageId", nil)

