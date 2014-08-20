import Foundation

public func nibbles(twoNibbles : UInt8) -> (UInt8, UInt8) {
    let left = twoNibbles >> 4;
    let right = twoNibbles & 0x0F
    return (left, right);
}