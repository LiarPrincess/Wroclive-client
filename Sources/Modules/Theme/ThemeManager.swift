//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ThemeManager {

  // MARK: - Fonts

  var textFont: Font { get }
  var iconFont: Font { get }

  func recalculateFontSizes()

  // MARK: - Color scheme

  var colors: ColorScheme { get }
  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor)
}

// MARK: - Text attributes

extension ThemeManager {

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         TextColor       = TextColor.text) -> [String:Any] {
    let result: [String:Any] = [
      NSFontAttributeName:            self.fontValue(fontType, textStyle),
      NSKernAttributeName:            self.trackingValue(fontType, textStyle),
      NSForegroundColorAttributeName: self.colorValue(color),
      NSParagraphStyleAttributeName:  self.paragraphStyle(alignment, lineSpacing)
    ]

    return result
  }

  private func colorValue(_ color: TextColor) -> UIColor {
    switch color {
    case .background:            return self.colors.background
    case .backgroundAccent:      return self.colors.backgroundAccent
    case .text:                  return self.colors.text
    case .tint:                  return self.colors.tintColor.value
    case .bus:                   return self.colors.busColor.value
    case .tram:                  return self.colors.tramColor.value
    case .presentationPrimary:   return self.colors.presentation.textPrimary
    case .presentationSecondary: return self.colors.presentation.textSecondary
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
