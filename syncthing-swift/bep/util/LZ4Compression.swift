import Foundation

public func compress(uncompressed : [UInt8]) -> [UInt8] {
    let lengthBytes = bytes(UInt32(uncompressed.count))
    return lengthBytes + unsigned(compress(signed(uncompressed)))
}

private func compress(uncompressed : [Int8]) -> [Int8] {
    var result = compressionBuffer(uncompressed)
    let compressedLength = LZ4_compress(
        uncompressed,
        &result,
        Int32(uncompressed.count)
    )
    result.removeRange(Int(compressedLength)..<result.count)
    return result
}

private func compressionBuffer(uncompressed : [Int8]) -> [Int8] {
    let maxCompressedLength = Int(LZ4_compressBound(Int32(uncompressed.count)))
    return [Int8](count: maxCompressedLength, repeatedValue: 0)
}

public func decompress(compressed : [UInt8]) -> [UInt8]? {
    var result = decompressionBuffer(compressed)
    if result != nil {
        if (result!.count > 0) {
            decompress(signed(Array(compressed[4..<compressed.count])), &result)
        }
        if result != nil {
            return unsigned(result!)
        }
    }
    return nil
}

private func decompressionBuffer(compressed : [UInt8]) -> [Int8]? {
    let uncompressedLength = extractLength(compressed)
    if uncompressedLength <= maxBufferLength {
        return [Int8](count: uncompressedLength, repeatedValue:0)
    } else {
        return nil
    }
}

private func extractLength(data : [UInt8]) -> Int {
    return Int(concatenateBytes(data[0], data[1], data[2], data[3]))
}

private func decompress(compressed : [Int8], inout decompressed : [Int8]?) {
    let decompressedLength = LZ4_decompress_safe(
        compressed,
        &decompressed!,
        Int32(compressed.count),
        Int32(decompressed!.count)
    )
    if (decompressedLength <= 0) {
        decompressed = nil
    }
}

private let maxBufferLength = 8 * 1024 * 1024
