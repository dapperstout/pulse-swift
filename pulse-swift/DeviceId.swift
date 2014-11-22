import Foundation

public class DeviceId: Printable {

    let hash: [UInt8]

    public init!(hash: [UInt8]) {
        self.hash = hash

        if (hash.count != 256) {
            return nil
        }
    }

    public var description: String {
        return join("-", base32Groups)
    }

    private var base32Groups: [String] {
        var result: [String] = []
        for i in 0...7 {
            let begin = advance(base32.startIndex, i*8)
            let end = advance(begin, 8)
            result.append(base32.substringWithRange(begin..<end))
        }
        return result
    }

    private var base32: String {
        var result = NSData(bytes: hash, length: hash.count).base32String()
        return result.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "="))
    }
}