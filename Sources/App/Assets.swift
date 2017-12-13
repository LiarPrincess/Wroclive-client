//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private class BundleHook {}

private func imageNamed(_ name: String) -> UIImage {
  let bundle = Bundle(for: BundleHook.self)
  return UIImage(named: name, in: bundle, compatibleWith: nil)!
}

enum Assets {
  static var shareImage: UIImage { return imageNamed("ShareImage") }
}
