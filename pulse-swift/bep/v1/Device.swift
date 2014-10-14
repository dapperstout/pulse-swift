import Foundation

public class Device : Equatable, XdrWritable {

    public let id: String
    public let isTrusted: Bool
    public let isReadOnly: Bool
    public let isIntroducer: Bool
    public let uploadPriority : UploadPriority
    public let maxLocalVersion : UInt64

    public init(
        id: String, trusted: Bool = true, readOnly: Bool = false,
        introducer: Bool = false, uploadPriority: UploadPriority = .Normal,
        maxLocalVersion: UInt64 = 0)
    {
        self.id = id
        self.isTrusted = trusted
        self.isReadOnly = readOnly
        self.isIntroducer = introducer
        self.uploadPriority = uploadPriority
        self.maxLocalVersion = maxLocalVersion
    }

    public class func readFrom(reader: XdrReader) -> Device? {
        if let id = reader.readString() {
        if let flags = reader.readUInt32() {
        if let maxLocalVersion = reader.readUInt64() {

            let isTrusted = bits(bytes(flags)[3])[7]
            let isReadOnly = bits(bytes(flags)[3])[6]
            let isIntroducer = bits(bytes(flags)[3])[5]
            let priorityBits = bytes(flags)[1] & 0b11

            return Device(
                id: id,
                trusted: isTrusted,
                readOnly: isReadOnly,
                introducer: isIntroducer,
                uploadPriority: UploadPriority.fromRaw(priorityBits)!,
                maxLocalVersion: maxLocalVersion
            )
        }}}
        return nil;
    }

    public func writeTo(writer: XdrWriter) {
        let prioFlags = uploadPriority.toRaw()
        let irtFlags = concatenateBits(
            false, false, false, false, false,
            isIntroducer, isReadOnly, isTrusted
        )

        writer.writeString(id)
        writer.writeUInt32(concatenateBytes(0, prioFlags, 0, irtFlags))
        writer.writeUInt64(self.maxLocalVersion)
    }
}

public enum UploadPriority : UInt8 {
    case Normal = 0b00
    case High = 0b01
    case Low = 0b10
    case SharingDisabled = 0b11
}

public func == (lhs: Device, rhs: Device) -> Bool {
    return
        lhs.id == rhs.id &&
        lhs.isTrusted == rhs.isTrusted &&
        lhs.isReadOnly == rhs.isReadOnly &&
        lhs.isIntroducer == rhs.isIntroducer &&
        lhs.uploadPriority == rhs.uploadPriority &&
        lhs.maxLocalVersion == rhs.maxLocalVersion
}
