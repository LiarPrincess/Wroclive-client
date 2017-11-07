//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

private class BundleHook {}

func localizedString(_ key: String) -> String {
  let bundle = Bundle(for: BundleHook.self)
  return NSLocalizedString(key, bundle: bundle, comment: "")
}
