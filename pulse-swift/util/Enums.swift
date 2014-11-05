import Foundation

extension NSNumber {

    public convenience init<T>(enumValue: T) {
        self.init(unsignedInt: unsafeBitCast(enumValue, UInt32.self))
    }

}