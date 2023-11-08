import Foundation
// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import os

import Flutter
import MSAL
import UIKit

extension FlutterError: Error {}

private class _PluginState {
    var publicClientApplication: MSALPublicClientApplication?
}

private let _state = _PluginState()

public class IntuneApiImpl: NSObject, IntuneApi {
    let logger = Logger(subsystem: "IntuneIosPlugin", category: "IntuneApiImpl")

    func getUnimplementedError() -> FlutterError {
        return FlutterError(code: "unimplemented", message: "unimplemented", details: nil)
    }

    func getUnknownError(_ reason: String?) -> FlutterError {
        return FlutterError(code: "unknown", message: reason ?? "Reason unknown", details: nil)
    }

    func getPublicClientApplicationError() -> FlutterError {
        return FlutterError(
            code: "config_error",
            message: "MSALPublicClientApplication was not created",
            details: nil
        )
    }

    func ping(hello: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("pong \(hello)"))
    }

    func registerAuthentication(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func registerAccountForMAM(upn _: String, aadId _: String, tenantId _: String, authorityURL _: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func unregisterAccountFromMAM(upn _: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func getRegisteredAccountStatus(upn _: String, completion: @escaping (Result<MAMEnrollmentStatusResult, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func createMicrosoftPublicClientApplication(
        publicClientApplicationConfiguration: [String: Any?],
        forceCreation: Bool,
        enableLogs _: Bool,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        if !forceCreation && _state.publicClientApplication != nil {
            logger.info("createMicrosoftPublicClientApplication: public client application already exist. To try creation forcibly, set [forceCreation] to `true`")
            completion(.success(true))
        }
        let clientId = publicClientApplicationConfiguration["client_id"]
        if !(clientId is String) {
            logger.error("Invalid [client_id: String] in PublicClientApplicationConfiguration")
            completion(.success(false))
        }
        let redirectUri = publicClientApplicationConfiguration["redirect_uri"] ?? getDefaultRedirectUri()
        if !(redirectUri is String) {
            logger.error("Invalid [redirectUri: String?] in PublicClientApplicationConfiguration")
            completion(.success(false))
        }
        let authority = publicClientApplicationConfiguration["authority"]
        var msalAuthority: MSALAuthority?
        if authority is String {
            do {
                msalAuthority = try MSALAuthority(url: URL(string: authority as! String)!)
            } catch {
                logger.warning("Failed to create MSALAuthority for '\(authority as! String)'")
            }
        }
        do {
            let config = MSALPublicClientApplicationConfig(
                clientId: clientId as! String,
                redirectUri: redirectUri as? String,
                authority: msalAuthority
            )
            let pca = try MSALPublicClientApplication(configuration: config)
            _state.publicClientApplication = pca
            completion(.success(true))
        } catch {
            logger.error("Failed to get all accounts (Error type \(type(of: error)). \nError description: \(error.localizedDescription)")
            completion(.failure(getUnknownError("Failed to create public client application \(error.localizedDescription)")))
        }
    }

    func getAccounts(completion: @escaping (Result<[MSALUserAccount], Error>) -> Void) {
        guard let pca = _state.publicClientApplication else {
            logger.warning("signOut: public client application was not initialized")
            completion(.failure(getPublicClientApplicationError()))
            return
        }
        do {
            let accounts = try pca.allAccounts().map { account in
                MSALUserAccount(
                    authority: account.tenantProfiles?.first?.environment ?? "",
                    id: account.identifier ?? "",
                    idToken: "",
                    tenantId: account.tenantProfiles?.first?.tenantId ?? "",
                    username: account.username ?? ""
                )
            }
            completion(.success(accounts))
        } catch {
            logger.error("Failed to get all accounts (Error type \(type(of: error)). \nError description: \(error.localizedDescription)")
            completion(.failure(getUnknownError("Failed to get accounts")))
        }
    }

    func acquireToken(params _: AcquireTokenParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func acquireTokenSilently(params _: AcquireTokenSilentlyParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }

    func signOut(
        aadId: String?,
        iosParameters: SignoutIOSParameters,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        Task {
            await signOutAsync(aadId: aadId, iosParameters: iosParameters, completion: completion)
        }
    }

    private func signOutAsync(
        aadId: String?,
        iosParameters: SignoutIOSParameters,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) async {
        guard let pca = _state.publicClientApplication else {
            logger.warning("signOut: public client application was not initialized")
            completion(.success(false))
            return
        }

        var account: MSALAccount?
        if aadId != nil {
            do {
                account = try pca.account(forUsername: aadId!)
            } catch {
                logger.error("Failed to get account by \(aadId ?? "").\nError description: \(error.localizedDescription)")
            }
        } else {
            do {
                account = try pca.allAccounts().first
            } catch {
                logger.error("No accounts in public client application.\nError description: \(error.localizedDescription)")
            }
        }
        if account == nil {
            completion(.success(false))
            return
        }

        do {
            let webViewParamaters = await getWebviewParameters(
                prefersEphemeralWebBrowserSession: iosParameters.prefersEphemeralWebBrowserSession
            )

            let params = MSALSignoutParameters(webviewParameters: webViewParamaters)
            params.signoutFromBrowser = iosParameters.signoutFromBrowser

            let result = try await pca.signout(with: account!, signoutParameters: params)

            completion(.success(result))
            intuneReply.onSignOut()
            return
        } catch {
            logger.error("Failed to signout (Error type \(type(of: error)). \nError description: \(error.localizedDescription)")
            intuneReply.onMSALException(error: error, stacktrace: Thread.callStackSymbols)
        }
        completion(.success(false))
    }

    private func getDefaultRedirectUri() -> String? {
        let bundleId = Bundle.main.bundleIdentifier
        if bundleId == nil {
            return nil
        }
        return "msauth.\(bundleId!)://auth"
    }

    private func getWebviewParameters(prefersEphemeralWebBrowserSession: Bool) async -> MSALWebviewParameters {
        let viewController: UIViewController = await (UIApplication.shared.delegate?.window??.rootViewController)!
        let webViewParamaters = MSALWebviewParameters(authPresentationViewController: viewController)
        if #available(iOS 13.0, *) {
            webViewParamaters.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
        }
        return webViewParamaters
    }
}
