//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension ThemeManager {

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         TextColor       = TextColor.text) -> [NSAttributedStringKey:Any] {
    return [
      NSAttributedStringKey.font:            self.fontValue(fontType, textStyle),
      NSAttributedStringKey.kern:            self.trackingValue(fontType, textStyle),
      NSAttributedStringKey.foregroundColor: self.colorValue(color),
      NSAttributedStringKey.paragraphStyle:  self.paragraphStyle(alignment, lineSpacing)
    ]
  }

  private func colorValue(_ color: TextColor) -> UIColor {
    switch color {
    case .background:            return self.colors.background
    case .accentLight:           return self.colors.accentLight
    case .accentDark:            return self.colors.accentDark
    case .text:                  return self.colors.text
    case .tint:                  return self.colors.tint.value
    case .bus:                   return self.colors.bus.value
    case .tram:                  return self.colors.tram.value
    }
  }

  private func fontValue(_ fontType: FontType, _ textStyle: TextStyle) -> UIFont {
    let font = self.font(ofType: fontType)
    switch textStyle {
    case .headline:    return font.headline
    case .subheadline: return font.subheadline
    case .body:        return font.body
    case .bodyBold:    return font.bodyBold
    case .caption:     return font.caption
    }
  }

  private func font(ofType fontType: FontType) -> Font {
    switch fontType {
    case .text: return self.textFont
    case .icon: return self.iconFont
    }
  }

  private func trackingValue(_ fontType: FontType, _ textStyle: TextStyle) -> CGFloat {
    let font = self.font(ofType: fontType)
    switch textStyle {
    case .headline:                  return font.headlineTracking
    case .subheadline:               return font.subheadlineTracking
    case .body, .bodyBold, .caption: return 0.0
    }
  }

  private func paragraphStyle(_ alignment: NSTextAlignment, _ lineSpacing: CGFloat) -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment   = alignment
    paragraphStyle.lineSpacing = lineSpacing
    return paragraphStyle
  }
}
