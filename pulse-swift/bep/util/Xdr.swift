import Foundation

public func xdr(objects : Any...) -> [UInt8]? {
    let writer = XdrWriter()
    for object in objects {
        switch(object) {
            case let string as String:
                writer.writeString(string)
            case let data as [UInt8]:
                writer.writeData(data)
            case let uint32 as UInt32:
                writer.writeUInt32(uint32)
            case let int32 as Int32:
                writer.writeInt32(int32)
            case let uint64 as UInt64:
                writer.writeUInt64(uint64)
            case let int64 as Int64:
                writer.writeInt64(int64)
            default:
                return nil
        }
    }
    return writer.xdrBytes
}
