// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

public protocol BundleManagerType {

  /// App name (e.g. Wroclive)
  var name: String { get }

  /// App version (e.g. 1.0)
  var version: String { get }

  /// App bundle (e.g. pl.nopoint.wroclive)
  var identifier: String { get }
}

public struct BundleManager: BundleManagerType {

  public let name: String
  public let version: String
  public let identifier: String

  public init(bundle: Bundle) {
    func get(key: String) -> String? {
      return bundle.infoDictionary?[key] as? String
    }

    self.name = get(key: kCFBundleExecutableKey as String) ?? "Unknown"
    self.version = get(key: "CFBundleShortVersionString") ?? "0"
    self.identifier = get(key: kCFBundleIdentifierKey as String) ?? "Unknown"
  }
}
