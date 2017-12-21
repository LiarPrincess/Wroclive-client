//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension ThemeManager {

  func textAttributes(for style:     TextStyle,
                      fontType font: FontType      = .text,
                      alignment:     TextAlignment = .natural,
                      lineSpacing:   CGFloat       = 0.0,
                      color:         TextColor     = TextColor.text) -> [NSAttributedStringKey:Any] {
    let attributes = TextAttributes(style: style, font: font, color: color, alignment: alignment, lineSpacing: lineSpacing)
    return attributes.value
  }
}
