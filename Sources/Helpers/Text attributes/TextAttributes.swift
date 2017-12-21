import UIKit

struct TextAttributes {

  // MARK: - Properties

  private var style:     TextStyle
  private var font:      FontType
  private var color:     TextColor
  private var alignment: TextAlignment

  private var lineSpacing:      CGFloat
  private var paragraphSpacing: CGFloat

  private var theme: ThemeManager { return Managers.theme }

  // MARK: - Init

  init(
    style:            TextStyle     = .body,
    font:             FontType      = .text,
    color:            TextColor     = .text,
    alignment:        TextAlignment = .natural,
    lineSpacing:      CGFloat       = 0.0,
    paragraphSpacing: CGFloat       = 0.0)
  {
    self.style     = style
    self.font      = font
    self.color     = color
    self.alignment = alignment
    self.lineSpacing      = lineSpacing
    self.paragraphSpacing = paragraphSpacing
  }

  // MARK: - Mutation

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

  mutating func withAlignment(_ alignment: TextAlignment) -> TextAttributes {
    self.alignment = alignment
    return self
  }

  mutating func withLineSpacing(_ lineSpacing: CGFloat) -> TextAttributes {
    self.lineSpacing = lineSpacing
    return self
  }

  mutating func withParagraphSpacing(_ paragraphSpacing: CGFloat) -> TextAttributes {
    self.paragraphSpacing = paragraphSpacing
    return self
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
    case .background:            return self.theme.colors.background
    case .accentLight:           return self.theme.colors.accentLight
    case .accentDark:            return self.theme.colors.accentDark
    case .text:                  return self.theme.colors.text
    case .tint:                  return self.theme.colors.tint.value
    case .bus:                   return self.theme.colors.bus.value
    case .tram:                  return self.theme.colors.tram.value
    }
  }

  private func fontValue() -> UIFont {
    let font = self.fontFamilyValue()
    switch self.style {
    case .headline:    return font.headline
    case .subheadline: return font.subheadline
    case .body:        return font.body
    case .bodyBold:    return font.bodyBold
    case .caption:     return font.caption
    }
  }

  private func trackingValue() -> CGFloat {
    let font = self.fontFamilyValue()
    switch self.style {
    case .headline:                  return font.headlineTracking
    case .subheadline:               return font.subheadlineTracking
    case .body, .bodyBold, .caption: return 0.0
    }
  }

  private func fontFamilyValue() -> Font {
    switch self.font {
    case .text: return self.theme.textFont
    case .icon: return self.theme.iconFont
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
