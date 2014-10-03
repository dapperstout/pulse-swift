import Foundation

public class XdrWriter {

    public private(set) var xdrBytes = [UInt8]()

    public init() {}

    public func writeString(string : String) {
        let utf8Bytes = string.utf8Bytes
        let padding = Repeat<UInt8>(count: 4 - (utf8Bytes.count % 4), repeatedValue: 0)
        xdrBytes += bytes(UInt32(utf8Bytes.count))
        xdrBytes += utf8Bytes
        xdrBytes += padding

    }

}