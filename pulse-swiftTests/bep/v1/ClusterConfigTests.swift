import XCTest
import pulse

class ClusterConfigTests: XCTestCase {

    func testIsType0() {
        XCTAssertEqual(someConfig.type, UInt8(0))
    }

    func testXdrEncodesClientName() {
        let reader = XdrReader(xdrBytes: someConfig.contents)
        XCTAssertEqual(reader.readString()!, someClientName)
    }

    func testXdrEncodesClientVersion() {
        let reader = XdrReader(xdrBytes: someConfig.contents)
        reader.readString()
        XCTAssertEqual(reader.readString()!, someClientVersion)
    }

    func testXdrEncodesFolders() {
        let reader = XdrReader(xdrBytes: someConfig.contents)
        reader.readString()
        reader.readString()
        XCTAssertEqual(reader.read([Folder])!, someFolders)
    }

    func testXdrEncodesOptions() {
        let reader = XdrReader(xdrBytes: someConfig.contents)
        reader.readString()
        reader.readString()
        reader.read([Folder])
        let options = reader.read(Options)!
        XCTAssertEqual(options, someOptions)
    }

    let someConfig = ClusterConfig(
        clientName: someClientName,
        clientVersion: someClientVersion,
        folders: someFolders,
        options: someOptions
    )
}

let someClientName = "Some Client Name"
let someClientVersion = "v0.4.2"
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
