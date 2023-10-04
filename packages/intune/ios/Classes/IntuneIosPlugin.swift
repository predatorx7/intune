// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation

import Flutter
import UIKit

public class IntuneIosPlugin: NSObject, FlutterPlugin, IntuneApi {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = IntuneIosPlugin()
        let messenger = registrar.messenger()
        IntuneApiSetup.setUp(binaryMessenger: messenger, api: instance)
    }

    func ping(hello: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("pong \(hello)"))
    }
}
