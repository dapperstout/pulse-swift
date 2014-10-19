import Foundation

public class Folder : Equatable, XdrWritable, XdrReadable {

    public let id: String
    public let devices: [Device]

    public required init(id: String, devices: [Device] = []) {
        self.id = id
        self.devices = devices
    }
    public func writeTo(writer: XdrWriter) {
        writer.writeString(id)
        writer.write(devices)
    }

    public class func readFrom(reader: XdrReader) -> Self? {
        if let id = reader.readString() {
            if let devices = reader.read([Device]) {
                return self(id: id, devices: devices)
            }
        }
        return nil
    }
}

public func == (lhs: Folder, rhs: Folder) -> Bool {
    return
        lhs.id == rhs.id &&
        lhs.devices == rhs.devices
}