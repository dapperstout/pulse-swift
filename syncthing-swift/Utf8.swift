import Foundation

public extension String {

    public static func fromUtf8Bytes<S: SequenceType where S.Generator.Element == UInt8>(bytes : S) -> String? {
        return self.stringWithBytes(bytes, encoding:NSUTF8StringEncoding)
    }

    public var utf8Bytes : [UInt8] {
        return [UInt8](self.utf8)
    }

}