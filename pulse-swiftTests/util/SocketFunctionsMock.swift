import XCTest
import Pulse

class SocketFunctionsMock: SocketFunctions {

    var returnedStreamProperty: AnyObject?

    var expectedStream: CFReadStream?
    var expectedPropertyName: CFString?

    override func CFReadStreamCopyProperty(stream: CFReadStream!, _ propertyName: CFString!) -> AnyObject! {
        if expectedStream != nil {
            XCTAssertTrue(expectedStream! === stream)
        }
        if expectedPropertyName != nil {
            XCTAssertEqual(String(expectedPropertyName!), String(propertyName))
        }
        return returnedStreamProperty
    }
}