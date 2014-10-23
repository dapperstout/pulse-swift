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

    public func writeInt32(int32 : Int32) -> XdrWriter {
        return writeUInt32(unsigned(int32))
    }

    public func writeUInt64(uint64 : UInt64) -> XdrWriter {
        xdrBytes += bytes(uint64)
        return self
    }

    public func writeInt64(int64: Int64) -> XdrWriter {
        return writeUInt64(unsigned(int64))
    }

    public func write(writable: XdrWritable) -> XdrWriter {
        writable.writeTo(self)
        return self
    }

    public func write<W: XdrWritable>(writables: [W]) -> XdrWriter {
        writeUInt32(UInt32(writables.count))
        for writable in writables {
            write(writable)
        }
        return self
    }
}

public protocol XdrWritable {
    func writeTo(writer: XdrWriter)
}