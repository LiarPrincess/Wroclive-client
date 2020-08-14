// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension NSAttributedString {
  public convenience init(string: String, attributes: TextAttributes) {
    self.init(string: string, attributes: attributes.value)
  }
}

public struct TextAttributes {

  // MARK: - Properties

  private var style:     TextStyle
  private var font:      FontType
  private var color:     TextColor
  private var alignment: TextAlignment

  private var lineSpacing:      CGFloat
  private var paragraphSpacing: CGFloat

  // MARK: - Init

  public init(
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

  public func withStyle(_ style: TextStyle) -> TextAttributes {
    return self.copy { $0.style = style }
  }

  public func withFont(_ font:  FontType) -> TextAttributes {
    return self.copy { $0.font = font }
  }

  public func withColor(_ color: TextColor) -> TextAttributes {
    return self.copy { $0.color = color }
  }

  public func withAlignment(_ alignment: TextAlignment) -> TextAttributes {
    return self.copy { $0.alignment = alignment }
  }

  public func withLineSpacing(_ lineSpacing: CGFloat) -> TextAttributes {
    return self.copy { $0.lineSpacing = lineSpacing }
  }

  public func withParagraphSpacing(_ paragraphSpacing: CGFloat) -> TextAttributes {
    return self.copy { $0.paragraphSpacing = paragraphSpacing }
  }

  private func copy(_ mutate: (inout TextAttributes) -> Void) -> TextAttributes {
    var copy = self
    mutate(&copy)
    return copy
  }

  // MARK: - Value

  public var value: [NSAttributedString.Key:Any] {
    return [
      NSAttributedString.Key.foregroundColor: self.colorValue(),
      NSAttributedString.Key.font:            self.fontValue(),
      NSAttributedString.Key.paragraphStyle:  self.paragraphStyleValue()
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
    case .largeTitle: return preset.largeTitle
    case .headline:   return preset.headline
    case .body:       return preset.body
    case .bodyBold:   return preset.bodyBold
    case .footnote:   return preset.footnote
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
