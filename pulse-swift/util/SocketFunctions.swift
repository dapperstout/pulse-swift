public class SocketFunctions {

    public init() {}

    public func CFReadStreamCopyProperty(stream: CFReadStream!, _ propertyName: CFString!) -> AnyObject! {
        return Foundation.CFReadStreamCopyProperty(stream, propertyName)
    }

    public func SecCertificateCopyData(certificate: SecCertificate!) -> Unmanaged<CFData>! {
        return Security.SecCertificateCopyData(certificate)
    }
}