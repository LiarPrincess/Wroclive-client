//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import Foundation

typealias Images = Assets

private class BundleHook {}

private func imageNamed(_ name: String) -> UIImage {
  let bundle = Bundle(for: BundleHook.self)
  return UIImage(named: name, in: bundle, compatibleWith: nil)!
}

struct Assets {

  struct InAppPurchase {
    static var bookmarks: UIImage { return imageNamed("Image_InApp_Bookmarks") }
    static var colors:    UIImage { return imageNamed("Image_InApp_Bookmarks") }
  }

  struct Theme {
    static var image: UIImage { return imageNamed("Image_InApp_Bookmarks") }
  }

  struct Tutorial {
    static var page0: UIImage { return imageNamed("Image_InApp_Bookmarks") }
    static var page1: UIImage { return imageNamed("Image_InApp_Bookmarks") }
    static var page2: UIImage { return imageNamed("Image_InApp_Bookmarks") }
  }

  static var deviceBorder: UIImage { return imageNamed("Image_DeviceBorder") }
  static var share:        UIImage { return imageNamed("Image_Share") }
}
