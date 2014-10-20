import Foundation

public class Options: Equatable, XdrWritable, XdrReadable {

    let options: Dictionary<String, String>

    public required init(_ options: Dictionary<String, String> = [:]) {
        self.options = options
    }

    public func writeTo(writer: XdrWriter) {
        writer.writeUInt32(UInt32(options.count))
        for (key, value) in options {
            writer.writeString(key)
            writer.writeString(value)
        }
    }

    public class func readFrom(reader: XdrReader) -> Self? {
        if let amount = reader.readUInt32() {
            var options = Dictionary<String, String>()
            for i in 0..<amount {
                if let (key, value) = readOption(reader) {
                    options[key] = value
                } else {
                    return nil
                }
            }
            return self(options)
        }
        return nil;
    }

    class func readOption(reader: XdrReader) -> (String, String)? {
        if let key = reader.readString() {
            if let value = reader.readString() {
                return (key, value)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

public func == (lhs: Options, rhs: Options) -> Bool {
    return lhs.options == rhs.options
}
