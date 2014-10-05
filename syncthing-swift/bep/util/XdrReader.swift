import Foundation

public class XdrReader {

    let xdrBytes : [UInt8]
    var index : Int = 0

    public init(xdrBytes : [UInt8]) {
        self.xdrBytes = xdrBytes
    }

    public func readString() -> String? {
        if let stringLength = readUInt32() {
            if let stringBytes = read(Int(stringLength)) {
                read(4 - (stringLength % 4))
                return String.fromUtf8Bytes(stringBytes)
            }
        }
        return nil
    }

    func readUInt32() -> UInt32? {
        if let bytes = read(4) {
            return concatenateBytes(bytes[0], bytes[1], bytes[2], bytes[3])
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

}
