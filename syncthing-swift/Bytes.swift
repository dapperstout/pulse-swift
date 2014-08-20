import Foundation

public func nibbles(twoNibbles : UInt8) -> (UInt8, UInt8) {
    let left = twoNibbles >> 4
    let right = twoNibbles & 0x0F
    return (left, right)
}

public func bytes(twoBytes : UInt16) -> (UInt8, UInt8) {
    let left = UInt8(twoBytes >> 8)
    let right = UInt8(twoBytes & 0xFF)
    return (left, right)
}

public func concatenateBytes(left : UInt8, right : UInt8) -> UInt16 {
    return UInt16(left) << 8 | UInt16(right)
}

public func concatenateNibbles(left : UInt8, right : UInt8) -> UInt8 {
    return left << 4 | right
}