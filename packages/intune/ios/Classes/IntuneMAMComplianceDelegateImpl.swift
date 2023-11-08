//
//  IntuneMAMComplianceDelegateImpl.swift
//  intune
//
//  Created by HDFCLTD on 06/11/23.
//

import Foundation
import IntuneMAMSwift

public class IntuneMAMComplianceDelegateImpl: NSObject, IntuneMAMComplianceDelegate {
    public func identity(
        _ identity: String,
        hasComplianceStatus status: IntuneMAMComplianceStatus,
        withErrorMessage errMsg: String,
        andErrorTitle errTitle: String
    ) {
        switch status {
        case .compliant:
            // Handle successful compliance
            print("Compliant!")
        case .notCompliant, .networkFailure, .serviceFailure, .userCancelled:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errTitle, message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    exit(0)
                }))
                // Send error to flutter to show a dialog
            }
        case .interactionRequired:
            IntuneMAMComplianceManager.instance()
                .remediateCompliance(forIdentity: identity, silent: false)
        default:
            print("Unknown compliance status value")
        }
    }
}
