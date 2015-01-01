import Foundation

public class Message
{
    public let id : UInt16
    public let type : UInt8
    public let isCompressed : Bool
    private let version : UInt8 = 0
    private let _contents : [UInt8]

    public init(id: UInt16? = nil, type : UInt8, contents : [UInt8] =  [], compress : Bool = true) {
        self.id = (id != nil) ? id! : getNextMessageId()
        self.type = type
        self._contents = compress ? Pulse.compress(contents) : contents
        self.isCompressed = compress
    }

    init(id: UInt16, type: UInt8, contents: [UInt8], isCompressed: Bool) {
        self.id = id
        self.type = type
        self._contents = contents
        self.isCompressed = isCompressed
    }

    public var contents : [UInt8] {
        return isCompressed ? decompress(_contents)! : _contents
    }

    public func serialize() -> [UInt8] {
        var result : [UInt8] = []
        let idBytes = bytes(id)
        let lengthBytes = bytes(UInt32(_contents.count))
        result.append(concatenateNibbles(version, idBytes[0]))
        result.append(idBytes[1])
        result.append(type)
        result.append(concatenateBits(false, false, false, false, false, false, false, isCompressed))
        result.extend(lengthBytes)
        result.extend(_contents)
        return result;
    }

    public class func deserialize(bytes: [UInt8]) -> Message? {
        return MessageParser().parse(bytes)
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
private let nextMessageIdLock = dispatch_queue_create("pulse.nextMessageId", nil)

