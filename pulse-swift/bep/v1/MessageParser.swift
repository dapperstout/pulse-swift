class MessageParser {

    func parse(bytes: [UInt8]) -> Message? {
        if bytes.count < numberOfBytesInHeader {
            return nil
        }

        let version = nibbles(bytes[0])[0]

        if (version != 0) {
            return nil
        }

        let id = concatenateBytes(nibbles(bytes[0])[1], bytes[1])
        let type = bytes[2]

        let length = concatenateBytes(bytes[4], bytes[5], bytes[6], bytes[7])
        let isCompressed = bits(bytes[3])[7]
        let contents = Array(bytes[8..<8+Int(length)])

        return Message(id: id, type: type, contents: contents, isCompressed: isCompressed)
    }

    let numberOfBytesInHeader = 4
}