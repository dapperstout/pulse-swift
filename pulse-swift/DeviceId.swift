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
        base32PlusChecks.processChunksOfSize(7) {
            result.append($0)
        }
        return result
    }

    private var base32PlusChecks: String {
        var result = ""
        base32.processChunksOfSize(13) {
            result = result + $0 + String(LuhnBase32Wrong.calculateCheckDigit($0))
        }
        return result
    }

    private var base32: String {
        var result = NSData(bytes: hash, length: hash.count).base32String()
        return result.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "="))
    }
}

extension String {

    func processChunksOfSize(chunkSize: Int, _ closure: (String)->()) {
        let amountOfChunks = countElements(self) / chunkSize
        var begin = self.startIndex
        for i in 0..<amountOfChunks {
            let end = advance(begin, chunkSize)
            let chunk = self[begin..<end]

            closure(chunk)

            begin = end
        }
    }
}