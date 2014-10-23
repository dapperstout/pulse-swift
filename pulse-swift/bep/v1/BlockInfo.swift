import Foundation

public class BlockInfo: Equatable, XdrWritable, XdrReadable {

    public let size: UInt32
    public let hash: [UInt8]

    public required init(size: UInt32, hash: [UInt8]) {
        self.size = size
        self.hash = hash
    }

    public func writeTo(writer: XdrWriter) {
        writer.writeUInt32(size)
        writer.writeData(hash)
    }

    public class func readFrom(reader: XdrReader) -> Self? {
        if let size = reader.readUInt32() {
            if let hash = reader.readData() {
                return self(size: size, hash: hash)
            }
        }
        return nil
    }
}

public func == (lhs: BlockInfo, rhs: BlockInfo) -> Bool {
    return
        lhs.size == rhs.size &&
        lhs.hash == rhs.hash
}