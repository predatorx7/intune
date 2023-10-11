// Copyright 2023, Mushaheed Syed. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation

import Flutter
import UIKit

public class IntuneIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = IntuneApiImpl()
        let messenger = registrar.messenger()
        IntuneApiSetup.setUp(binaryMessenger: messenger, api: instance)
    }
}
