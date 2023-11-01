// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation

import Flutter
import UIKit

public class IntuneApiImpl: NSObject, IntuneApi {
    func ping(hello: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("pong \(hello)"))
        
    }

    func registerAuthentication(completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
    }
    
    func registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func unregisterAccountFromMAM(upn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func getRegisteredAccountStatus(upn: String, completion: @escaping (Result<MAMEnrollmentStatusResult, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: [String : Any?], forceCreation: Bool, enableLogs: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func getAccounts(completion: @escaping (Result<[MSALUserAccount], Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func acquireToken(params: AcquireTokenParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func acquireTokenSilently(params: AcquireTokenSilentlyParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
    
    func signOut(aadId: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.error("unimplemented"))
        
    }
}
