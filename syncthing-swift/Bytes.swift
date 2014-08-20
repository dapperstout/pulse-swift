import Foundation

public func bits(eightBits : UInt8) -> [Bool] {
    var result : [Bool] = []
    var mask = UInt8(0b10000000)
    for _ in 0..<8 {
        result.append((eightBits & mask) != 0)
        mask >>= 1
    }
    return result
}

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

public func bytes(fourBytes : UInt32) -> (UInt8, UInt8, UInt8, UInt8) {
    let b0 = UInt8(fourBytes >> 24)
    let b1 = UInt8((fourBytes >> 16) & 0xFF)
    let b2 = UInt8((fourBytes >> 8) & 0xFF)
    let b3 = UInt8((fourBytes) & 0xFF)
    return (b0, b1, b2, b3)
}

public func concatenateBits(eightBits : Bool...)  -> UInt8 {
    return concatenateBits(eightBits)
}

public func concatenateBits(eightBits : [Bool]) -> UInt8 {
    var result : UInt8 = 0
    for bit in eightBits {
        result <<= 1
        if (bit) {
            result = result | 1
        }
    }
    return result;
}

public func concatenateNibbles(left : UInt8, right : UInt8) -> UInt8 {
    return left << 4 | right
}

public func concatenateBytes(left : UInt8, right : UInt8) -> UInt16 {
    return UInt16(left) << 8 | UInt16(right)
}

public func concatenateBytes(b0 : UInt8, b1 : UInt8, b2 : UInt8, b3 : UInt8) -> UInt32 {
    return UInt32(b0) << 24 | UInt32(b1) << 16 | UInt32(b2) << 8 | UInt32(b3);
}
