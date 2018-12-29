// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

struct TextAttributes {

  // MARK: - Properties

  private var style:     TextStyle
  private var font:      FontType
  private var color:     TextColor
  private var alignment: TextAlignment

  private var lineSpacing:      CGFloat
  private var paragraphSpacing: CGFloat

  // MARK: - Init

  init(
    style:            TextStyle     = .body,
    font:             FontType      = .text,
    color:            TextColor     = .text,
    alignment:        TextAlignment = .natural,
    lineSpacing:      CGFloat       = 0.0,
    paragraphSpacing: CGFloat       = 0.0) {
    self.style     = style
    self.font      = font
    self.color     = color
    self.alignment = alignment
    self.lineSpacing      = lineSpacing
    self.paragraphSpacing = paragraphSpacing
  }

  // MARK: - Mutation

  func withStyle(_ style: TextStyle) -> TextAttributes {
    return self.copy { $0.style = style }
  }

  func withFont(_ font:  FontType) -> TextAttributes {
    return self.copy { $0.font = font }
  }

  func withColor(_ color: TextColor) -> TextAttributes {
    return self.copy { $0.color = color }
  }

  func withAlignment(_ alignment: TextAlignment) -> TextAttributes {
    return self.copy { $0.alignment = alignment }
  }

  func withLineSpacing(_ lineSpacing: CGFloat) -> TextAttributes {
    return self.copy { $0.lineSpacing = lineSpacing }
  }

  func withParagraphSpacing(_ paragraphSpacing: CGFloat) -> TextAttributes {
    return self.copy { $0.paragraphSpacing = paragraphSpacing }
  }

  private func copy(_ mutate: (inout TextAttributes) -> Void) -> TextAttributes {
    var copy = self
    mutate(&copy)
    return copy
  }

  // MARK: - Value

  var value: [NSAttributedStringKey:Any] {
    return [
      NSAttributedStringKey.foregroundColor: self.colorValue(),
      NSAttributedStringKey.font:            self.fontValue(),
      NSAttributedStringKey.kern:            self.trackingValue(),
      NSAttributedStringKey.paragraphStyle:  self.paragraphStyleValue()
    ]
  }

  private func colorValue() -> UIColor {
    switch self.color {
    case .background:  return Theme.colors.background
    case .accentLight: return Theme.colors.accentLight
    case .accentDark:  return Theme.colors.accentDark
    case .text:        return Theme.colors.text
    case .tint:        return Theme.colors.tint
    case .bus:         return Theme.colors.bus
    case .tram:        return Theme.colors.tram
    }
  }

  private func fontValue() -> UIFont {
    let preset = self.fontPresetValue()
    switch self.style {
    case .headline:    return preset.headline
    case .subheadline: return preset.subheadline
    case .body:        return preset.body
    case .bodyBold:    return preset.bodyBold
    case .caption:     return preset.caption
    }
  }

  private func trackingValue() -> CGFloat {
    let preset = self.fontPresetValue()
    switch self.style {
    case .headline:                  return preset.headlineTracking
    case .subheadline:               return preset.subheadlineTracking
    case .body, .bodyBold, .caption: return 0.0
    }
  }

  private func fontPresetValue() -> FontPreset {
    switch self.font {
    case .text: return Theme.textFont
    case .icon: return Theme.iconFont
    }
  }

  private func paragraphStyleValue() -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment              = self.alignmentValue()
    paragraphStyle.lineSpacing            = self.lineSpacing
    paragraphStyle.paragraphSpacingBefore = self.paragraphSpacing
    return paragraphStyle
  }

  private func alignmentValue() -> NSTextAlignment {
    switch self.alignment {
    case .left:    return NSTextAlignment.left
    case .right:   return NSTextAlignment.right
    case .center:  return NSTextAlignment.center
    case .natural: return NSTextAlignment.natural
    }
  }
}
