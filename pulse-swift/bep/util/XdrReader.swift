import Foundation

public class XdrReader {

    let xdrBytes : [UInt8]
    var index : Int = 0

    public init(xdrBytes : [UInt8]) {
        self.xdrBytes = xdrBytes
    }

    public func readString() -> String? {
        if let stringBytes = readData() {
            return String.fromUtf8Bytes(stringBytes)
        }
        return nil
    }

    public func readData() -> [UInt8]? {
        if let length = readUInt32() {
            if let bytes = read(Int(length)) {
                read(4 - (length % 4))
                return [UInt8](bytes)
            }
        }
        return nil
    }

    public func readUInt32() -> UInt32? {
        if let bytes = read(4) {
            return concatenateBytes(bytes[0], bytes[1], bytes[2], bytes[3])
        }
        return nil
    }

    public func readUInt64() -> UInt64? {
        if let bytes = read(8) {
            return concatenateBytes(
                bytes[0], bytes[1], bytes[2], bytes[3],
                bytes[4], bytes[5], bytes[6], bytes[7]
            )
        }
        return nil
    }

    func read(amount: Int) -> Slice<UInt8>? {
        if (index + amount <= xdrBytes.count) {
            let result = xdrBytes[index..<index + amount]
            index += amount
            return result
        }
        return nil
    }

    public func read<T: XdrReadable>(T.Type) -> T? {
        return T.readFrom(self)
    }

    public func read<T: XdrReadable>(Array<T>.Type) -> [T]? {
        if let amount = self.readUInt32() {
            var result: [T] = []
            for i in 0..<amount {
                if let t = read(T) {
                    result.append(t)
                } else {
                    return nil
                }
            }
            return result
        }
        return nil
    }
}

public protocol XdrReadable {

    class func readFrom(reader: XdrReader) -> Self?;

}
