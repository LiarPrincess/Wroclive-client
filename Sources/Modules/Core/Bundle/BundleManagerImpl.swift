//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BundleManagerImpl: BundleManager {

  var name:       String { return self.bundleInformation(key: kCFBundleExecutableKey as String) ?? "Unknown" }
  var version:    String { return self.bundleInformation(key: "CFBundleShortVersionString")     ?? "0" }
  var identifier: String { return self.bundleInformation(key: kCFBundleIdentifierKey as String) ?? "Unknown" }

  private func bundleInformation(key: String) -> String? {
    return Bundle.main.infoDictionary?[key] as? String
  }
}
