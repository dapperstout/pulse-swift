extension SecIdentity {

    public var certificate: SecCertificate {
        var certificate: Unmanaged<SecCertificate>?
        SecIdentityCopyCertificate(self, &certificate)
        return certificate!.takeRetainedValue()
    }
}