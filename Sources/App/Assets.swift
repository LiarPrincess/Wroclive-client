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
    static var bookmarks: UIImage { return imageNamed("Image_InApp_Bookmarks")}
  }

  struct Theme {
    static var image: UIImage { return imageNamed("Image_Map_Background") }
  }

  struct Toolbars {
    static var red:    UIImage { return imageNamed("Image_01_Toolbar_Red"   )}
    static var blue:   UIImage { return imageNamed("Image_02_Toolbar_Blue"  )}
    static var green:  UIImage { return imageNamed("Image_03_Toolbar_Green" )}
    static var orange: UIImage { return imageNamed("Image_04_Toolbar_Orange")}
    static var pink:   UIImage { return imageNamed("Image_05_Toolbar_Pink"  )}
    static var black:  UIImage { return imageNamed("Image_06_Toolbar_Black" )}
  }

  struct Tutorial {
    static var page0: UIImage { return imageNamed("Image_Map_Background") }
    static var page1: UIImage { return imageNamed("Image_Map_Background") }
    static var page2: UIImage { return imageNamed("Image_Map_Background") }
  }

  static var deviceBorder:  UIImage { return imageNamed("Image_DeviceBorder") }
  static var mapBackground: UIImage { return imageNamed("Image_Map_Background") }
  static var share:         UIImage { return imageNamed("Image_Share") }
}
