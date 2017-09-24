//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ThemeManager {

  // MARK: - Color scheme

  var colorScheme: ColorScheme { get }

  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor)

  // MARK: - Text attributes

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType,
                      alignment:     NSTextAlignment,
                      lineSpacing:   CGFloat,
                      color:         TextColor) -> [String:Any]

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType,
                      alignment:     NSTextAlignment,
                      lineSpacing:   CGFloat,
                      color:         UIColor) -> [String:Any]
}

extension ThemeManager {

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         TextColor       = TextColor.text) -> [String:Any] {
    return self.textAttributes(for: textStyle, fontType: fontType, alignment: alignment, lineSpacing: lineSpacing, color: color)
  }

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         UIColor) -> [String:Any] {
    return self.textAttributes(for: textStyle, fontType: fontType, alignment: alignment, lineSpacing: lineSpacing, color: color)
  }
}
