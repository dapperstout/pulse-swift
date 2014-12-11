import XCTest
import pulse

class SocketFunctionsMock: SocketFunctions {

    var returnedStreamProperty: AnyObject?
    var returnedCertificateData: Unmanaged<CFData>?

    var expectedStream: CFReadStream?
    var expectedPropertyName: CFString?
    var expectedCertificate: SecCertificate?

    override func CFReadStreamCopyProperty(stream: CFReadStream!, _ propertyName: CFString!) -> AnyObject! {
        if expectedStream != nil {
            XCTAssertTrue(expectedStream! === stream)
        }
        if expectedPropertyName != nil {
            XCTAssertEqual(String(expectedPropertyName!), String(propertyName))
        }
        return returnedStreamProperty
    }

    override func SecCertificateCopyData(certificate: SecCertificate!) -> Unmanaged<CFData>! {
        if (expectedCertificate != nil) {
            XCTAssertTrue(expectedCertificate! === certificate)
        }
        return returnedCertificateData
    }
}