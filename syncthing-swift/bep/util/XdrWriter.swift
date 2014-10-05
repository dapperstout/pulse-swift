import Foundation

public class XdrWriter {

    public private(set) var xdrBytes = [UInt8]()

    public init() {}

    public func writeString(string : String) -> XdrWriter {
        writeData(string.utf8Bytes)
        return self
    }

    public func writeData(data : [UInt8]) -> XdrWriter {
        let padding = Repeat<UInt8>(count: 4 - (data.count % 4), repeatedValue: 0)
        xdrBytes += bytes(UInt32(data.count))
        xdrBytes += data
        xdrBytes += padding
        return self
    }

    public func writeUInt32(uint32 : UInt32) -> XdrWriter {
        xdrBytes += bytes(uint32)
        return self
    }

    public func writeUInt64(uint64 : UInt64) -> XdrWriter {
        xdrBytes += bytes(uint64)
        return self
    }

}