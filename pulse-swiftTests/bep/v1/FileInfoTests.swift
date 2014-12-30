import XCTest
import Pulse

class FileInfoTests: XCTestCase {

    func testXdrEncodesItsName() {
        let reader = xdrReader(someFileInfo)
        XCTAssertEqual(reader.readString()!, someFileInfo.name)
    }

    func testXdrEncodesItsDeletionBit() {
        let flags = readFlags(FileInfo(name: "", deleted: true))
        let deletionBit = bits(bytes(flags)[2])[3]
        XCTAssertTrue(deletionBit)
    }

    func testXdrEncodesItsInvalidBit() {
        let flags = readFlags(FileInfo(name: "", invalid: true))
        let invalidBit = bits(bytes(flags)[2])[2]
        XCTAssertTrue(invalidBit)
    }

    func testXdrEncodesItsNoPermissionsBit() {
        let flags = readFlags(FileInfo(name: "", noPermissions: true))
        let noPermissionsBit = bits(bytes(flags)[2])[1]
        XCTAssertTrue(noPermissionsBit)
    }

    func testXdrEncodesItsUnixPermissions() {
        let flags = readFlags(FileInfo(name: "", permissions: somePermissions))
        let permissions = concatenateBytes(bytes(flags)[2], bytes(flags)[3]) & 0x0FFF
        XCTAssertEqual(permissions, somePermissions)
    }

    func testXdrEncodesItsModificationTime() {
        let modificationDate = readModificationDate(someFileInfo)
        XCTAssertEqual(modificationDate, someFileInfo.modificationDate)
    }

    func testXdrEncodesItsVersion() {
        let version = readVersion(someFileInfo)
        XCTAssertEqual(version, someFileInfo.version)
    }

    func testXdrEncodesItsLocalVersion() {
        let localVersion = readLocalVersion(someFileInfo)
        XCTAssertEqual(localVersion, someFileInfo.localVersion)
    }

    func testXdrEncodesItsBlockInfo() {
        let blocks = readBlocks(someFileInfo)
        XCTAssertEqual(blocks, someFileInfo.blocks)
    }

    func testCanBeReadFromXdr() {
        let reader = xdrReader(someFileInfo)
        let fileInfo = reader.read(FileInfo)!
        XCTAssertEqual(fileInfo, someFileInfo)
    }

    func readFlags(fileInfo: FileInfo) -> UInt32 {
        let reader = xdrReader(fileInfo)
        reader.readString()
        return reader.readUInt32()!
    }

    func readModificationDate(fileInfo: FileInfo) -> NSDate {
        let reader = xdrReader(fileInfo)
        reader.readString()
        reader.readUInt32()
        return NSDate(timeIntervalSince1970: (Double(reader.readInt64()!)))
    }

    func readVersion(fileInfo: FileInfo) -> UInt64 {
        let reader = xdrReader(fileInfo)
        reader.readString()
        reader.readUInt32()
        reader.readInt64()
        return reader.readUInt64()!
    }

    func readLocalVersion(fileInfo: FileInfo) -> UInt64 {
        let reader = xdrReader(fileInfo)
        reader.readString()
        reader.readUInt32()
        reader.readInt64()
        reader.readUInt64()
        return reader.readUInt64()!
    }

    func readBlocks(fileInfo: FileInfo) -> [BlockInfo] {
        let reader = xdrReader(fileInfo)
        reader.readString()
        reader.readUInt32()
        reader.readInt64()
        reader.readUInt64()
        reader.readUInt64()!
        return reader.read([BlockInfo])!
    }

    func xdrReader(fileInfo: FileInfo) -> XdrReader {
        let xdrBytes = XdrWriter().write(fileInfo).xdrBytes
        return XdrReader(xdrBytes: xdrBytes)
    }

    let someFileInfo = FileInfo(
        name: "Some Name",
        blocks: [
            BlockInfo(size: 42, hash:[12, 34]),
            BlockInfo(size: 76, hash:[56, 78])
        ],
        deleted: true,
        invalid: false,
        noPermissions: true,
        permissions: 0o7654,
        modificationDate: NSDate(timeIntervalSince1970: 42),
        version: 31,
        localVersion: 36
    )

    let somePermissions: UInt16 = 0o7162

}