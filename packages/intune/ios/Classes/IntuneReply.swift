//
//  IntuneReply.swift
//  intune
//
//  Created by HDFCLTD on 06/11/23.
//

import Foundation
import IntuneMAMSwift

class IntuneReply {
    private var intuneFlutterApi: IntuneFlutterApi!;

    public func setIntuneFlutterApi(api: IntuneFlutterApi) {
        intuneFlutterApi = api;
    }
    
    func updateCompliance(status: IntuneMAMComplianceStatus) {
        var enrollmentResult: MAMEnrollmentStatus
        switch status {
        case .compliant:
            enrollmentResult = MAMEnrollmentStatus.eNROLLMENTSUCCEEDED;
            break;
        case .notCompliant, .networkFailure, .serviceFailure, .userCancelled:
            enrollmentResult = MAMEnrollmentStatus.eNROLLMENTFAILED;
            break;
        default:
            enrollmentResult = MAMEnrollmentStatus.uNEXPECTED;
        }
        intuneFlutterApi.onEnrollmentNotification(
            enrollmentResult: MAMEnrollmentStatusResult(result: enrollmentResult),
            completion: <#T##() -> Void#>
        )
    }
}

var intuneReply: IntuneReply = IntuneReply()

