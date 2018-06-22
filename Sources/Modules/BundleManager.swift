// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

class BundleManager: BundleManagerType {

  var name:       String { return self.bundleInformation(key: kCFBundleExecutableKey as String) ?? "Unknown" }
  var version:    String { return self.bundleInformation(key: "CFBundleShortVersionString")     ?? "0" }
  var identifier: String { return self.bundleInformation(key: kCFBundleIdentifierKey as String) ?? "Unknown" }

  private func bundleInformation(key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }
}
