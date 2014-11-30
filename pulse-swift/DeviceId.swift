import Foundation

public class DeviceId: Printable {

    let hash: [UInt8]

    public init!(hash: [UInt8]) {
        self.hash = hash

        if (hash.count != 256 / 8) {
            return nil
        }
    }

    public var description: String {
        return join("-", base32Groups)
    }

    private var base32Groups: [String] {
        var result: [String] = []
        var begin = base32.startIndex
        for i in 0..<8 {
            let end = advance(begin, 8)
            result.append(base32[begin..<end])
            begin = end
        }
        return result
    }

    private var base32: String {
        var result = NSData(bytes: hash, length: hash.count).base32String()
        return result.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "="))
    }
}