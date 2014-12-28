extension SecCertificate {

    public var data: NSData {
        return SecCertificateCopyData(self).takeRetainedValue()
    }
}