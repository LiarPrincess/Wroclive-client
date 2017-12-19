import UIKit

struct TextAttributes {

  // MARK: - Properties

  private var style:  TextStyle
  private var font:   FontType
  private var color:  TextColor

  private var alignment:   TextAlignment
  private var lineSpacing: CGFloat

  private var theme: ThemeManager { return Managers.theme }

  // MARK: - Init

  init(
    style:       TextStyle     = .body,
    font:        FontType      = .text,
    color:       TextColor     = .text,
    alignment:   TextAlignment = .natural,
    lineSpacing: CGFloat       = 0.0) {
  self.style        = style
  self.font         = font
  self.color        = color
  self.alignment    = alignment
  self.lineSpacing  = lineSpacing
  }

  // MARK: - Properties

  mutating func withStyle(_ style: TextStyle) -> TextAttributes {
    self.style = style
    return self
  }

  mutating func withFont(_ font:  FontType) -> TextAttributes {
    self.font = font
    return self
  }

  mutating func withColor(_ color: TextColor) -> TextAttributes {
    self.color = color
    return self
  }

  mutating func withAlignment(_ alignment:   TextAlignment) -> TextAttributes {
    self.alignment = alignment
    return self
  }

  mutating func withLineSpacing(_ lineSpacing: CGFloat) -> TextAttributes {
    self.lineSpacing = lineSpacing
    return self
  }

  // MARK: - Render

  func render(_ value: String) -> NSAttributedString {
    let attributes = self.asAttributedDictionary()
    return NSAttributedString(string: value, attributes: attributes)
  }

  func asAttributedDictionary() -> [NSAttributedStringKey:Any] {
    return [
      NSAttributedStringKey.foregroundColor: self.colorValue(self.color),
      NSAttributedStringKey.font:            self.fontValue(self.font, self.style),
      NSAttributedStringKey.kern:            self.trackingValue(self.font, self.style),
      NSAttributedStringKey.paragraphStyle:  self.paragraphStyleValue(self.alignment, self.lineSpacing)
    ]
  }

  private func colorValue(_ color: TextColor) -> UIColor {
    switch color {
    case .background:            return self.theme.colors.background
    case .accentLight:           return self.theme.colors.accentLight
    case .accentDark:            return self.theme.colors.accentDark
    case .text:                  return self.theme.colors.text
    case .tint:                  return self.theme.colors.tint.value
    case .bus:                   return self.theme.colors.bus.value
    case .tram:                  return self.theme.colors.tram.value
    }
  }

  private func fontValue(_ type: FontType, _ style: TextStyle) -> UIFont {
    let font = self.fontFamilyValue(type)
    switch style {
    case .headline:    return font.headline
    case .subheadline: return font.subheadline
    case .body:        return font.body
    case .bodyBold:    return font.bodyBold
    case .caption:     return font.caption
    }
  }

  private func trackingValue(_ type: FontType, _ style: TextStyle) -> CGFloat {
    let font = self.fontFamilyValue(type)
    switch style {
    case .headline:                  return font.headlineTracking
    case .subheadline:               return font.subheadlineTracking
    case .body, .bodyBold, .caption: return 0.0
    }
  }

  private func fontFamilyValue(_ type: FontType) -> Font {
    switch type {
    case .text: return self.theme.textFont
    case .icon: return self.theme.iconFont
    }
  }

  private func paragraphStyleValue(_ alignment: TextAlignment, _ lineSpacing: CGFloat) -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment   = self.alignmentValue(alignment)
    paragraphStyle.lineSpacing = lineSpacing
    return paragraphStyle
  }

  private func alignmentValue(_ alignment: TextAlignment) -> NSTextAlignment {
    switch alignment {
    case .left:    return NSTextAlignment.left
    case .right:   return NSTextAlignment.right
    case .center:  return NSTextAlignment.center
    case .natural: return NSTextAlignment.natural
    }
  }
}
