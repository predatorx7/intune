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
        
    }
    
    func registerAccountForMAM(upn: String, aadId: String, tenantId: String, authorityURL: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func unregisterAccountFromMAM(upn: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func getRegisteredAccountStatus(upn: String, completion: @escaping (Result<MAMEnrollmentStatusResult, Error>) -> Void) {
        
    }
    
    func createMicrosoftPublicClientApplication(publicClientApplicationConfiguration: [String : Any?], forceCreation: Bool, enableLogs: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func getAccounts(completion: @escaping (Result<[MSALUserAccount], Error>) -> Void) {
        
    }
    
    func acquireToken(params: AcquireTokenParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func acquireTokenSilently(params: AcquireTokenSilentlyParams, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func signOut(aadId: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
}
