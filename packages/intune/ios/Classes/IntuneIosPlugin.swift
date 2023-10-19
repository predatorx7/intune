// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation

import Flutter
import UIKit
import MSAL

public class IntuneIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        onPluginRegister();
        let api = IntuneApiImpl()
        let messenger = registrar.messenger()
        IntuneApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
    
    private static func onPluginRegister() {
        MSALGlobalConfig.loggerConfig.logMaskingLevel = .settingsMaskAllPII
        MSALGlobalConfig.loggerConfig.logLevel = .verbose
    }
}
