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
      static let closeImageSize = CGSize(width: 15.0, height: 15.0)
    }

    struct Content {
      static let scrollHiddenPercent: CGFloat = 0.17
    }

    struct Footer {
      static let topInset:    CGFloat =  5.0
      static let bottomInset: CGFloat = 20.0

      static let lineSpacing: CGFloat = 5.0
    }
  }

  struct Localization {
    static let Title = "Settings"
    static let Footer = "Data provided by MPK Wrocław\nKek version 1.0"

    struct Colors {
      static let title = "Colors"
    }

    struct Share {
      static let title = "Share"

      struct Content {
        static let text  = "Make London’s buses work for you. Check out Jump for iPhone. www.kekapp.pl"
        static let image = #imageLiteral(resourceName: "Image_Share")
      }
    }

    struct Tutorial {
      static let title = "Tutorial"
    }

    struct Rate {
      static let title = "Rate"
    }
  }
}
