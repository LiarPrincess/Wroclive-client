//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {
  let text:    UIColor
  let primary: UIColor

  let background:         UIColor
  let backgroundContrast: UIColor
}

extension ColorScheme {

  static var light: ColorScheme {
    return ColorScheme(
      text:    UIColor.black,
      primary: UIColor(red: 1.00, green: 0.22, blue: 0.14, alpha: 1.00),

      background:         UIColor.white,
      backgroundContrast: UIColor.lightGray
    )
  }

}
