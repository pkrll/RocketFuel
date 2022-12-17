//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

public struct ConfigurationProfile {
    
    public static var isInstalled: Bool {
        guard let path = Bundle.main.url(forResource: "Leaf", withExtension: "cer"),
              let data = try? Data(contentsOf: path),
              let cert = SecCertificateCreateWithData(nil, data as CFData)
        else {
            return false
        }

        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        var trustResult: SecTrustResultType = .invalid

        let err: OSStatus = SecTrustCreateWithCertificates(cert, policy, &trust)
        debugPrint(err)

        guard let trust = trust else {
            return false
        }

        SecTrustGetTrustResult(trust, &trustResult)

        return trustResult == .proceed
    }
}
