import Foundation

public class FileInfo : Equatable, XdrWritable, XdrReadable {

    public let name: String
    public let blocks: [BlockInfo]
    public let permissions: UInt16
    public let isDeleted: Bool
    public let isInvalid: Bool
    public let hasNoPermissions: Bool
    public let modificationDate: NSDate
    public let version: UInt64
    public let localVersion: UInt64

    public required init(name: String,
        blocks: [BlockInfo] = [],
        deleted: Bool = false, invalid: Bool = false, noPermissions: Bool = false,
        permissions: UInt16 = 0o0666,
        modificationDate: NSDate = NSDate(timeIntervalSince1970: 0),
        version: UInt64 = 0,
        localVersion: UInt64 = 0)
    {
        self.name = name
        self.permissions = permissions & 0x0FFF
        self.isDeleted = deleted
        self.isInvalid = invalid
        self.hasNoPermissions = noPermissions
        self.modificationDate = modificationDate
        self.version = version
        self.localVersion = localVersion
        self.blocks = blocks
    }

    public func writeTo(writer: XdrWriter) {
        writer.writeString(name)
        writer.writeUInt32(flags)
        writer.writeInt64(Int64(modificationDate.timeIntervalSince1970))
        writer.writeUInt64(version)
        writer.writeUInt64(localVersion)
        writer.write(blocks)
    }

    var flags: UInt32 {
        let pidBits = concatenateBits(false, hasNoPermissions, isInvalid, isDeleted)
            let permissionBytes = bytes(permissions)
            let thirdByte = concatenateNibbles(pidBits, permissionBytes[0])
            let fourthByte = permissionBytes[1]
            return concatenateBytes(0, 0, thirdByte, fourthByte)
    }

    public class func readFrom(reader: XdrReader) -> Self? {
        if let name = reader.readString() {
        if let flags = reader.readUInt32() {
        if let modificationDate = reader.readUInt64() {
        if let version = reader.readUInt64() {
        if let localVersion = reader.readUInt64() {
        if let blocks = reader.read([BlockInfo]) {

            let thirdByte = bytes(flags)[2]
            let fourthByte = bytes(flags)[3]
            let pidBits = bits(nibbles(thirdByte)[0])

            return self(
                name: name,
                blocks: blocks,
                deleted: pidBits[7],
                invalid: pidBits[6],
                noPermissions: pidBits[5],
                permissions: concatenateBytes(nibbles(thirdByte)[1], fourthByte),
                modificationDate: NSDate(timeIntervalSince1970: Double(modificationDate)),
                version: version,
                localVersion: localVersion
            )

        }}}}}}
        return nil;
    }
}

public func == (lhs: FileInfo, rhs: FileInfo) -> Bool {
    return lhs.name == rhs.name &&
        lhs.blocks == rhs.blocks &&
        lhs.isDeleted == rhs.isDeleted &&
        lhs.isInvalid == rhs.isInvalid &&
        lhs.hasNoPermissions == rhs.hasNoPermissions &&
        lhs.permissions == rhs.permissions &&
        lhs.modificationDate == rhs.modificationDate &&
        lhs.version == rhs.version &&
        lhs.localVersion == rhs.localVersion
}
