//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ConfigurationViewControllerConstants {

  struct Layout {
    static let leftInset:  CGFloat = 16.0
    static let rightInset: CGFloat = leftInset

    struct NavigationBar {
      static let closeImageSize = CGSize(width: 16.0, height: 16.0)
    }

    struct Footer {
      static let topInset:    CGFloat = 10.0
      static let bottomInset: CGFloat = 25.0

      static let lineSpacing: CGFloat = 5.0
    }
  }

  struct Localization {
    static let Title = "Settings"

    static let ItemColors   = "Settings"
    static let ItemShare    = "Tell a friend"
    static let ItemTutorial = "Tutorial"
    static let ItemRate     = "Rate"

    static let Footer = "Data provided by MPK Wrocław\nKek version 1.0"
  }

}
