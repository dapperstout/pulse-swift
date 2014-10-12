import XCTest
import pulse

public class FolderTests : XCTestCase {

    func testXdrEncodesItsId() {
        let folder = Folder(id: "Some Id")
        XCTAssertEqual(readId(folder), folder.id)
    }

    func testXdrEncodesNumberOfDevices() {
        let folder = Folder(id: "", devices: someDevices)
        XCTAssertEqual(readNumberOfDevices(folder), UInt32(someDevices.count))
    }

    func testXdrEncodesDevices() {
        let folder = Folder(id: "", devices: someDevices)
        XCTAssertEqual(readDevices(folder), someDevices)
    }

    func testCanBeReadFromXdr() {
        let folder = Folder(id: "Some Id", devices: someDevices)
        let reader = xdrReader(folder)
        XCTAssertEqual(Folder.readFrom(reader)!, folder)
    }

    func readId(folder: Folder) -> String {
        let reader = xdrReader(folder)
        return reader.readString()!
    }

    func readNumberOfDevices(folder: Folder) -> UInt32 {
        let reader = xdrReader(folder)
        reader.readString()
        return reader.readUInt32()!
    }

    func xdrReader(folder: Folder) -> XdrReader {
        return XdrReader(xdrBytes: xdr(folder))
    }

    func xdr(folder : Folder) -> [UInt8] {
        let writer = XdrWriter()
        folder.writeTo(writer)
        return writer.xdrBytes
    }

    func readDevices(folder: Folder) -> [Device] {
        let reader = xdrReader(folder)
        reader.readString()
        let numberOfDevices = reader.readUInt32()!
        return readDevices(reader, amount: numberOfDevices)
    }

    func readDevices(reader: XdrReader, amount: UInt32) -> [Device] {
        var devices: [Device] = []
        for i in 0..<amount {
            devices.append(Device.readFrom(reader)!)
        }
        return devices
    }

    let someDevices = [Device(id: "Device 1"), Device(id: "Device 2")]
}