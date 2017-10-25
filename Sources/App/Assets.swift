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

  struct Colors {
    static var background: UIImage { return imageNamed("Image_Colors_Background")}
    static var trams:      UIImage { return imageNamed("Image_Colors_Trams")}
    static var busses:     UIImage { return imageNamed("Image_Colors_Busses")}
    static var toolbar:    UIImage { return imageNamed("Image_Colors_Toolbar")}
  }

  struct Tutorial {
    static var page0: UIImage { return imageNamed("Image_Map_Background") }
    static var page1: UIImage { return imageNamed("Image_Map_Background") }
    static var page2: UIImage { return imageNamed("Image_Map_Background") }
  }

  struct Device {
    static var border: UIImage { return imageNamed("Image_Device_Border") }
  }

  static var share: UIImage { return imageNamed("Image_Share") }
}
