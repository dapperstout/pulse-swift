import XCTest
import Pulse

class ClusterConfigTests: XCTestCase {

    func testIsType0() {
        XCTAssertEqual(message.type, UInt8(0))
    }

    func testXdrEncodesClientName() {
        let reader = XdrReader(xdrBytes: message.contents)
        XCTAssertEqual(reader.readString()!, config.clientName)
    }

    func testXdrEncodesClientVersion() {
        let reader = XdrReader(xdrBytes: message.contents)
        reader.readString()
        XCTAssertEqual(reader.readString()!, config.clientVersion)
    }

    func testXdrEncodesFolders() {
        let reader = XdrReader(xdrBytes: message.contents)
        reader.readString()
        reader.readString()
        XCTAssertEqual(reader.read([Folder])!, config.folders)
    }

    func testXdrEncodesOptions() {
        let reader = XdrReader(xdrBytes: message.contents)
        reader.readString()
        reader.readString()
        reader.read([Folder])
        let options = reader.read(Options)!
        XCTAssertEqual(options, config.options)
    }

    let config = ClusterConfig.example
    let message = ClusterConfig.example.encode()
}

extension ClusterConfig {
    public class var example: ClusterConfig {
        let someFolders = [
                Folder(id: "Folder 1", devices: [
                        Device(id: "Device 1"),
                        Device(id: "Device 2")
                ]),
                Folder(id: "Folder 2", devices: [
                        Device(id: "Device 3")
                ])
        ]
        let someOptions = Options([
                "Key 1" : "Value 1",
                "Key 2" : "Value 2"
        ])
        return ClusterConfig(clientName: "Some Client Name",
                clientVersion: "v04.2",
                folders: someFolders,
                options: someOptions
        )
    }
}
