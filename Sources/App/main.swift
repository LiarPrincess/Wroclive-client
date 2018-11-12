// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private let isTesting = NSClassFromString("XCTestCase") != nil
private let appDelegate: AnyClass = isTesting ? TestAppDelegate.self : AppDelegate.self

private let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
_ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(UIApplication.self), NSStringFromClass(appDelegate))
