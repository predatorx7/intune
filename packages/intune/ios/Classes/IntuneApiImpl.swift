// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation

import Flutter
import UIKit

extension FlutterError: Error {}

public class IntuneApiImpl: NSObject, IntuneApi {
    func getUnimplementedError() -> FlutterError {
        return FlutterError(code: "1", message: "unimplemented", details: "")
    }

    func ping(hello: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("pong \(hello)"))
    }

    func registerAuthentication(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func unregisterAccountFromMAM(upn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func getRegisteredAccountStatus(upn: String, completion: @escaping (Result<MAMEnrollmentStatusResult, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: [String : Any?], forceCreation: Bool, enableLogs: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func getAccounts(completion: @escaping (Result<[MSALUserAccount], Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func acquireToken(params: AcquireTokenParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
        
    }
    
    func acquireTokenSilently(params: AcquireTokenSilentlyParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
    
    func signOut(aadId: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.failure(getUnimplementedError()))
    }
}
