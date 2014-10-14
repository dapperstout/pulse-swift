import Foundation

public class Folder : Equatable, XdrWritable {

    public let id: String
    public let devices: [Device]

    public init(id: String, devices: [Device] = []) {
        self.id = id
        self.devices = devices
    }

    public class func readFrom(reader: XdrReader) -> Folder? {
        if let id = reader.readString() {
        if let devices = readDevices(reader) {
            return Folder(id: id, devices: devices)
        }}
        return nil
    }

    private class func readDevices(reader: XdrReader) -> [Device]? {
        if let amountOfDevices = reader.readUInt32() {
            var devices: [Device] = []
            for i in 0..<amountOfDevices {
                if let device = Device.readFrom(reader) {
                    devices.append(device)
                } else {
                    return nil
                }
            }
            return devices
        }
        return nil
    }

    public func writeTo(writer: XdrWriter) {
        writer.writeString(id)
        writer.write(devices)
    }
}

public func == (lhs: Folder, rhs: Folder) -> Bool {
    return
        lhs.id == rhs.id &&
        lhs.devices == rhs.devices
}