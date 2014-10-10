import XCTest
import pulse

class DeviceTests : XCTestCase {

    func testXdrEncodesItsId() {
        let device = Device(id:"Some Id")
        XCTAssertEqual(readId(device), device.id)
    }

    func testXdrEncodesTrustedBit() {
        let device = Device(id:"", trusted: true)
        let flags = readFlags(device)

        XCTAssertEqual(bits(bytes(flags)[3])[7], device.isTrusted)
    }

    func testXdrEncodesReadOnlyBit() {
        let device = Device(id:"", readOnly: true)
        let flags = readFlags(device)

        XCTAssertEqual(bits(bytes(flags)[3])[6], device.isReadOnly)
    }

    func testXdrEncodesIntroducerBit() {
        let device = Device(id:"", introducer: true)
        let flags = readFlags(device)

        XCTAssertEqual(bits(bytes(flags)[3])[5], device.isIntroducer)
    }

    func testXdrEncodesUploadPriority() {
        for priority: UploadPriority in [.Normal, .High, .Low, .SharingDisabled] {
            let device = Device(id:"", uploadPriority:priority)
            let expectedPriorityBits = bits(priority.toRaw())[6...7]

            let flags = readFlags(device)
            let actualPriorityBits = bits(bytes(flags)[1])[6...7]

            XCTAssertEqual(actualPriorityBits, expectedPriorityBits)
        }
    }

    func testXdrEncodesMaxLocalVersion() {
        let device = Device(id: "", maxLocalVersion:42)
        XCTAssertEqual(readMaxLocalVersion(device), device.maxLocalVersion)
    }

    func testCanBeReadFromXdr() {
        let device = Device(
            id: "Some Id", trusted: false, readOnly: true,
            introducer: true, uploadPriority: .High, maxLocalVersion: 42
        )
        let reader = xdrReader(device)
        XCTAssertEqual(Device.readFrom(reader)!, device)
    }

    func readId(device: Device) -> String {
        let reader = xdrReader(device)
        return reader.readString()!
    }

    func readFlags(device: Device) -> UInt32 {
        let reader = xdrReader(device)
        reader.readString()
        return reader.readUInt32()!
    }

    func readMaxLocalVersion(device: Device) -> UInt64 {
        let reader = xdrReader(device)
        reader.readString()
        reader.readUInt32()
        return reader.readUInt64()!
    }

    func xdrReader(device: Device) -> XdrReader {
        return XdrReader(xdrBytes: xdr(device))
    }

    func xdr(device: Device) -> [UInt8] {
        let writer = XdrWriter()
        device.writeTo(writer)
        return writer.xdrBytes
    }

}

