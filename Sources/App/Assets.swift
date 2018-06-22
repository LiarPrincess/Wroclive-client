// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private class BundleHook { }

private func imageNamed(_ name: String) -> UIImage {
  let bundle = Bundle(for: BundleHook.self)
  return UIImage(named: name, in: bundle, compatibleWith: nil)!
}

enum Assets {
  static var shareImage: UIImage { return imageNamed("ShareImage") }
}
