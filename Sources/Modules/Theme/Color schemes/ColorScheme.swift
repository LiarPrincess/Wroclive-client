//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

struct ColorScheme {
  let text:       UIColor
  let primary:    UIColor
  let background: UIColor
}

extension ColorScheme {

  static var light: ColorScheme {
    let text       = UIColor.black
    let primary    = UIColor.black
    let background = UIColor.white

    return ColorScheme(text: text, primary: primary, background: background)
  }

}
