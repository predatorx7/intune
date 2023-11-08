//
//  IntuneReply.swift
//  intune
//
//  Created by HDFCLTD on 06/11/23.
//

import Foundation
import IntuneMAMSwift

private func _doNothing() {
    // do nothing
}

class IntuneReply {
    private var intuneFlutterApi: IntuneFlutterApi!

    public func setIntuneFlutterApi(api: IntuneFlutterApi) {
        intuneFlutterApi = api
    }

    func updateCompliance(status: IntuneMAMComplianceStatus) {
        var enrollmentResult: MAMEnrollmentStatus
        switch status {
        case .compliant:
            enrollmentResult = MAMEnrollmentStatus.eNROLLMENTSUCCEEDED
        case .notCompliant, .networkFailure, .serviceFailure, .userCancelled:
            enrollmentResult = MAMEnrollmentStatus.eNROLLMENTFAILED
        default:
            enrollmentResult = MAMEnrollmentStatus.uNEXPECTED
        }
        intuneFlutterApi.onEnrollmentNotification(
            enrollmentResult: MAMEnrollmentStatusResult(result: enrollmentResult),
            completion: _doNothing
        )
    }

    func onSignOut() {
        intuneFlutterApi.onSignOut(completion: _doNothing)
    }

    func onMSALException(error: Error, stacktrace: [String]) {
        intuneFlutterApi.onMsalException(
            exception: MSALApiException(
                errorCode: error.localizedDescription,
                stackTraceAsString: stacktrace.joined(separator: "\n")
            ),
            completion: _doNothing
        )
    }
}

var intuneReply: IntuneReply = .init()
