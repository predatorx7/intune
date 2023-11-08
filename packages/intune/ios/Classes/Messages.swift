// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Autogenerated from Pigeon (v9.2.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
    import Flutter
#elseif os(macOS)
    import FlutterMacOS
#else
    #error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
    return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
    if let flutterError = error as? FlutterError {
        return [
            flutterError.code,
            flutterError.message,
            flutterError.details,
        ]
    }
    return [
        "\(error)",
        "\(type(of: error))",
        "Stacktrace: \(Thread.callStackSymbols)",
    ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
    if value is NSNull { return nil }
    return (value as Any) as! T?
}

enum MSALLoginPrompt: Int {
    case consent = 0
    case create = 1
    case login = 2
    case selectAccount = 3
    case whenRequired = 4
}

enum MAMEnrollmentStatus: Int {
    case aUTHORIZATIONNEEDED = 0
    case nOTLICENSED = 1
    case eNROLLMENTSUCCEEDED = 2
    case eNROLLMENTFAILED = 3
    case wRONGUSER = 4
    case mDMENROLLED = 5
    case uNENROLLMENTSUCCEEDED = 6
    case uNENROLLMENTFAILED = 7
    case pENDING = 8
    case cOMPANYPORTALREQUIRED = 9
    case uNEXPECTED = 10
}

enum MSALErrorType: Int {
    case intuneAppProtectionPolicyRequired = 0
    case userCancelledSignInRequest = 1
    case unknown = 2
}

/// Generated class from Pigeon that represents data sent in messages.
struct AcquireTokenParams {
    var scopes: [String?]
    var correlationId: String? = nil
    var authority: String? = nil
    var loginHint: String? = nil
    var prompt: MSALLoginPrompt? = nil
    var extraScopesToConsent: [String?]? = nil

    static func fromList(_ list: [Any]) -> AcquireTokenParams? {
        let scopes = list[0] as! [String?]
        let correlationId: String? = nilOrValue(list[1])
        let authority: String? = nilOrValue(list[2])
        let loginHint: String? = nilOrValue(list[3])
        var prompt: MSALLoginPrompt?
        let promptEnumVal: Int? = nilOrValue(list[4])
        if let promptRawValue = promptEnumVal {
            prompt = MSALLoginPrompt(rawValue: promptRawValue)!
        }
        let extraScopesToConsent: [String?]? = nilOrValue(list[5])

        return AcquireTokenParams(
            scopes: scopes,
            correlationId: correlationId,
            authority: authority,
            loginHint: loginHint,
            prompt: prompt,
            extraScopesToConsent: extraScopesToConsent
        )
    }

    func toList() -> [Any?] {
        return [
            scopes,
            correlationId,
            authority,
            loginHint,
            prompt?.rawValue,
            extraScopesToConsent,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct AcquireTokenSilentlyParams {
    var aadId: String
    var scopes: [String?]
    var correlationId: String? = nil

    static func fromList(_ list: [Any]) -> AcquireTokenSilentlyParams? {
        let aadId = list[0] as! String
        let scopes = list[1] as! [String?]
        let correlationId: String? = nilOrValue(list[2])

        return AcquireTokenSilentlyParams(
            aadId: aadId,
            scopes: scopes,
            correlationId: correlationId
        )
    }

    func toList() -> [Any?] {
        return [
            aadId,
            scopes,
            correlationId,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MAMEnrollmentStatusResult {
    var result: MAMEnrollmentStatus? = nil

    static func fromList(_ list: [Any]) -> MAMEnrollmentStatusResult? {
        var result: MAMEnrollmentStatus?
        let resultEnumVal: Int? = nilOrValue(list[0])
        if let resultRawValue = resultEnumVal {
            result = MAMEnrollmentStatus(rawValue: resultRawValue)!
        }

        return MAMEnrollmentStatusResult(
            result: result
        )
    }

    func toList() -> [Any?] {
        return [
            result?.rawValue,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MSALApiException {
    var errorCode: String
    var message: String? = nil
    var stackTraceAsString: String

    static func fromList(_ list: [Any]) -> MSALApiException? {
        let errorCode = list[0] as! String
        let message: String? = nilOrValue(list[1])
        let stackTraceAsString = list[2] as! String

        return MSALApiException(
            errorCode: errorCode,
            message: message,
            stackTraceAsString: stackTraceAsString
        )
    }

    func toList() -> [Any?] {
        return [
            errorCode,
            message,
            stackTraceAsString,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MSALErrorResponse {
    var errorType: MSALErrorType

    static func fromList(_ list: [Any]) -> MSALErrorResponse? {
        let errorType = MSALErrorType(rawValue: list[0] as! Int)!

        return MSALErrorResponse(
            errorType: errorType
        )
    }

    func toList() -> [Any?] {
        return [
            errorType.rawValue,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MSALUserAccount {
    var authority: String
    /// aadid
    var id: String
    var idToken: String? = nil
    var tenantId: String
    /// upn
    var username: String

    static func fromList(_ list: [Any]) -> MSALUserAccount? {
        let authority = list[0] as! String
        let id = list[1] as! String
        let idToken: String? = nilOrValue(list[2])
        let tenantId = list[3] as! String
        let username = list[4] as! String

        return MSALUserAccount(
            authority: authority,
            id: id,
            idToken: idToken,
            tenantId: tenantId,
            username: username
        )
    }

    func toList() -> [Any?] {
        return [
            authority,
            id,
            idToken,
            tenantId,
            username,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct MSALUserAuthenticationDetails {
    var accessToken: String
    var account: MSALUserAccount
    var authenticationScheme: String
    var correlationId: Int64? = nil
    var expiresOnISO8601: String
    var scope: [String?]

    static func fromList(_ list: [Any]) -> MSALUserAuthenticationDetails? {
        let accessToken = list[0] as! String
        let account = MSALUserAccount.fromList(list[1] as! [Any])!
        let authenticationScheme = list[2] as! String
        let correlationId: Int64? = list[3] is NSNull ? nil : (list[3] is Int64? ? list[3] as! Int64? : Int64(list[3] as! Int32))
        let expiresOnISO8601 = list[4] as! String
        let scope = list[5] as! [String?]

        return MSALUserAuthenticationDetails(
            accessToken: accessToken,
            account: account,
            authenticationScheme: authenticationScheme,
            correlationId: correlationId,
            expiresOnISO8601: expiresOnISO8601,
            scope: scope
        )
    }

    func toList() -> [Any?] {
        return [
            accessToken,
            account.toList(),
            authenticationScheme,
            correlationId,
            expiresOnISO8601,
            scope,
        ]
    }
}

/// Generated class from Pigeon that represents data sent in messages.
struct SignoutIOSParameters {
    var signoutFromBrowser: Bool
    var prefersEphemeralWebBrowserSession: Bool

    static func fromList(_ list: [Any]) -> SignoutIOSParameters? {
        let signoutFromBrowser = list[0] as! Bool
        let prefersEphemeralWebBrowserSession = list[1] as! Bool

        return SignoutIOSParameters(
            signoutFromBrowser: signoutFromBrowser,
            prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession
        )
    }

    func toList() -> [Any?] {
        return [
            signoutFromBrowser,
            prefersEphemeralWebBrowserSession,
        ]
    }
}

private class IntuneApiCodecReader: FlutterStandardReader {
    override func readValue(ofType type: UInt8) -> Any? {
        switch type {
        case 128:
            return AcquireTokenParams.fromList(readValue() as! [Any])
        case 129:
            return AcquireTokenSilentlyParams.fromList(readValue() as! [Any])
        case 130:
            return MAMEnrollmentStatusResult.fromList(readValue() as! [Any])
        case 131:
            return MSALApiException.fromList(readValue() as! [Any])
        case 132:
            return MSALErrorResponse.fromList(readValue() as! [Any])
        case 133:
            return MSALUserAccount.fromList(readValue() as! [Any])
        case 134:
            return MSALUserAuthenticationDetails.fromList(readValue() as! [Any])
        case 135:
            return SignoutIOSParameters.fromList(readValue() as! [Any])
        default:
            return super.readValue(ofType: type)
        }
    }
}

private class IntuneApiCodecWriter: FlutterStandardWriter {
    override func writeValue(_ value: Any) {
        if let value = value as? AcquireTokenParams {
            super.writeByte(128)
            super.writeValue(value.toList())
        } else if let value = value as? AcquireTokenSilentlyParams {
            super.writeByte(129)
            super.writeValue(value.toList())
        } else if let value = value as? MAMEnrollmentStatusResult {
            super.writeByte(130)
            super.writeValue(value.toList())
        } else if let value = value as? MSALApiException {
            super.writeByte(131)
            super.writeValue(value.toList())
        } else if let value = value as? MSALErrorResponse {
            super.writeByte(132)
            super.writeValue(value.toList())
        } else if let value = value as? MSALUserAccount {
            super.writeByte(133)
            super.writeValue(value.toList())
        } else if let value = value as? MSALUserAuthenticationDetails {
            super.writeByte(134)
            super.writeValue(value.toList())
        } else if let value = value as? SignoutIOSParameters {
            super.writeByte(135)
            super.writeValue(value.toList())
        } else {
            super.writeValue(value)
        }
    }
}

private class IntuneApiCodecReaderWriter: FlutterStandardReaderWriter {
    override func reader(with data: Data) -> FlutterStandardReader {
        return IntuneApiCodecReader(data: data)
    }

    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        return IntuneApiCodecWriter(data: data)
    }
}

class IntuneApiCodec: FlutterStandardMessageCodec {
    static let shared = IntuneApiCodec(readerWriter: IntuneApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol IntuneApi {
    func registerAuthentication(completion: @escaping (Result<Bool, Error>) -> Void)
    func registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func unregisterAccountFromMAM(upn: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func getRegisteredAccountStatus(upn: String, completion: @escaping (Result<MAMEnrollmentStatusResult, Error>) -> Void)
    func createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: [String: Any?], forceCreation: Bool, enableLogs: Bool, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAccounts(completion: @escaping (Result<[MSALUserAccount], Error>) -> Void)
    func acquireToken(params: AcquireTokenParams, completion: @escaping (Result<Bool, Error>) -> Void)
    func acquireTokenSilently(params: AcquireTokenSilentlyParams, completion: @escaping (Result<Bool, Error>) -> Void)
    func signOut(aadId: String?, iosParameters: SignoutIOSParameters, completion: @escaping (Result<Bool, Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
enum IntuneApiSetup {
    /// The codec used by IntuneApi.
    static var codec: FlutterStandardMessageCodec { IntuneApiCodec.shared }
    /// Sets up an instance of `IntuneApi` to handle messages through the `binaryMessenger`.
    static func setUp(binaryMessenger: FlutterBinaryMessenger, api: IntuneApi?) {
        let registerAuthenticationChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.registerAuthentication", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            registerAuthenticationChannel.setMessageHandler { _, reply in
                api.registerAuthentication { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            registerAuthenticationChannel.setMessageHandler(nil)
        }
        let registerAccountForMAMChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.registerAccountForMAM", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            registerAccountForMAMChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let upnArg = args[0] as! String
                let aadIdArg = args[1] as! String
                let tenantIdArg = args[2] as! String
                let authorityURLArg = args[3] as! String
                api.registerAccountForMAM(upn: upnArg, aadId: aadIdArg, tenantId: tenantIdArg, authorityURL: authorityURLArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            registerAccountForMAMChannel.setMessageHandler(nil)
        }
        let unregisterAccountFromMAMChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.unregisterAccountFromMAM", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            unregisterAccountFromMAMChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let upnArg = args[0] as! String
                api.unregisterAccountFromMAM(upn: upnArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            unregisterAccountFromMAMChannel.setMessageHandler(nil)
        }
        let getRegisteredAccountStatusChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.getRegisteredAccountStatus", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            getRegisteredAccountStatusChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let upnArg = args[0] as! String
                api.getRegisteredAccountStatus(upn: upnArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            getRegisteredAccountStatusChannel.setMessageHandler(nil)
        }
        let createMicrosoftPublicClientApplicationChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.createMicrosoftPublicClientApplication", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            createMicrosoftPublicClientApplicationChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let publicClientApplicationConfigurationArg = args[0] as! [String: Any?]
                let forceCreationArg = args[1] as! Bool
                let enableLogsArg = args[2] as! Bool
                api.createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: publicClientApplicationConfigurationArg, forceCreation: forceCreationArg, enableLogs: enableLogsArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            createMicrosoftPublicClientApplicationChannel.setMessageHandler(nil)
        }
        let getAccountsChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.getAccounts", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            getAccountsChannel.setMessageHandler { _, reply in
                api.getAccounts { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            getAccountsChannel.setMessageHandler(nil)
        }
        let acquireTokenChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.acquireToken", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            acquireTokenChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let paramsArg = args[0] as! AcquireTokenParams
                api.acquireToken(params: paramsArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            acquireTokenChannel.setMessageHandler(nil)
        }
        let acquireTokenSilentlyChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.acquireTokenSilently", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            acquireTokenSilentlyChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let paramsArg = args[0] as! AcquireTokenSilentlyParams
                api.acquireTokenSilently(params: paramsArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            acquireTokenSilentlyChannel.setMessageHandler(nil)
        }
        let signOutChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneApi.signOut", binaryMessenger: binaryMessenger, codec: codec)
        if let api = api {
            signOutChannel.setMessageHandler { message, reply in
                let args = message as! [Any]
                let aadIdArg: String? = nilOrValue(args[0])
                let iosParametersArg = args[1] as! SignoutIOSParameters
                api.signOut(aadId: aadIdArg, iosParameters: iosParametersArg) { result in
                    switch result {
                    case let .success(res):
                        reply(wrapResult(res))
                    case let .failure(error):
                        reply(wrapError(error))
                    }
                }
            }
        } else {
            signOutChannel.setMessageHandler(nil)
        }
    }
}

private class IntuneFlutterApiCodecReader: FlutterStandardReader {
    override func readValue(ofType type: UInt8) -> Any? {
        switch type {
        case 128:
            return MAMEnrollmentStatusResult.fromList(readValue() as! [Any])
        case 129:
            return MSALApiException.fromList(readValue() as! [Any])
        case 130:
            return MSALErrorResponse.fromList(readValue() as! [Any])
        case 131:
            return MSALUserAccount.fromList(readValue() as! [Any])
        case 132:
            return MSALUserAuthenticationDetails.fromList(readValue() as! [Any])
        default:
            return super.readValue(ofType: type)
        }
    }
}

private class IntuneFlutterApiCodecWriter: FlutterStandardWriter {
    override func writeValue(_ value: Any) {
        if let value = value as? MAMEnrollmentStatusResult {
            super.writeByte(128)
            super.writeValue(value.toList())
        } else if let value = value as? MSALApiException {
            super.writeByte(129)
            super.writeValue(value.toList())
        } else if let value = value as? MSALErrorResponse {
            super.writeByte(130)
            super.writeValue(value.toList())
        } else if let value = value as? MSALUserAccount {
            super.writeByte(131)
            super.writeValue(value.toList())
        } else if let value = value as? MSALUserAuthenticationDetails {
            super.writeByte(132)
            super.writeValue(value.toList())
        } else {
            super.writeValue(value)
        }
    }
}

private class IntuneFlutterApiCodecReaderWriter: FlutterStandardReaderWriter {
    override func reader(with data: Data) -> FlutterStandardReader {
        return IntuneFlutterApiCodecReader(data: data)
    }

    override func writer(with data: NSMutableData) -> FlutterStandardWriter {
        return IntuneFlutterApiCodecWriter(data: data)
    }
}

class IntuneFlutterApiCodec: FlutterStandardMessageCodec {
    static let shared = IntuneFlutterApiCodec(readerWriter: IntuneFlutterApiCodecReaderWriter())
}

/// Generated class from Pigeon that represents Flutter messages that can be called from Swift.
class IntuneFlutterApi {
    private let binaryMessenger: FlutterBinaryMessenger
    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    var codec: FlutterStandardMessageCodec {
        return IntuneFlutterApiCodec.shared
    }

    func onEnrollmentNotification(enrollmentResult enrollmentResultArg: MAMEnrollmentStatusResult, completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onEnrollmentNotification", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage([enrollmentResultArg] as [Any?]) { _ in
            completion()
        }
    }

    func onUnexpectedEnrollmentNotification(completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onUnexpectedEnrollmentNotification", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage(nil) { _ in
            completion()
        }
    }

    func onMsalException(exception exceptionArg: MSALApiException, completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onMsalException", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage([exceptionArg] as [Any?]) { _ in
            completion()
        }
    }

    func onErrorType(response responseArg: MSALErrorResponse, completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onErrorType", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage([responseArg] as [Any?]) { _ in
            completion()
        }
    }

    func onUserAuthenticationDetails(details detailsArg: MSALUserAuthenticationDetails, completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onUserAuthenticationDetails", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage([detailsArg] as [Any?]) { _ in
            completion()
        }
    }

    func onSignOut(completion: @escaping () -> Void) {
        let channel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.IntuneFlutterApi.onSignOut", binaryMessenger: binaryMessenger, codec: codec)
        channel.sendMessage(nil) { _ in
            completion()
        }
    }
}
