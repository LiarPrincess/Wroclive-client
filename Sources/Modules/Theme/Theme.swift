//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class Theme {

  // Mark - Properties

  fileprivate(set) var systemFont      = SystemFont()
  fileprivate(set) var fontAwesomeFont = FontAwesomeFont()

  fileprivate(set) var colorScheme: ColorScheme

  // Mark - Init

  init(colorScheme: ColorScheme) {
    self.colorScheme = colorScheme
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  // MARK: - Text attributes

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         Color           = Color.text) -> [String:Any] {
    let colorValue = self.colorValue(color)
    return self.textAttributes(for: textStyle, fontType: fontType, alignment: alignment, lineSpacing: lineSpacing, color: colorValue)
  }

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType        = .text,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         UIColor) -> [String:Any] {
    return [
      NSFontAttributeName:            self.fontValue(fontType, textStyle),
      NSKernAttributeName:            self.trackingValue(fontType, textStyle),
      NSForegroundColorAttributeName: color,
      NSParagraphStyleAttributeName:  self.paragraphStyle(alignment, lineSpacing)
    ]
  }

  private func colorValue(_ color: Color) -> UIColor {
    switch color {
    case .background:       return self.colorScheme.background
    case .backgroundAccent: return self.colorScheme.backgroundAccent
    case .text:             return self.colorScheme.text
    case .tint:             return self.colorScheme.tint
    case .bus:              return self.colorScheme.bus
    case .tram:             return self.colorScheme.tram
    }
  }

  private func font(ofType fontType: FontType) -> Font {
    return fontType == .icon ? self.fontAwesomeFont : self.systemFont
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

  private func trackingValue(_ fontType: FontType, _ textStyle: TextStyle) -> CGFloat {
    let font = self.font(ofType: fontType)
    switch textStyle {
    case .headline:    return font.headlineTracking
    case .subheadline: return font.subheadlineTracking
    case .body,
         .bodyBold,
         .caption:
      return 0.0
    }
  }

  private func paragraphStyle(_ alignment: NSTextAlignment, _ lineSpacing: CGFloat) -> NSParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment   = alignment
    paragraphStyle.lineSpacing = lineSpacing
    return paragraphStyle
  }

  // MARK: - View styles

  func applyCardPanelStyle(_ view: UIView) {
    view.backgroundColor = self.colorScheme.background
    view.roundTopCorners(radius: 8.0)
  }

  func applyCardPanelHeaderStyle(_ view: UIView) {
    view.addBorder(at: .bottom)
    view.setContentHuggingPriority(900, for: .vertical)
  }

  func applyToolbarStyle(_ toolbar: UIToolbar) {
    toolbar.barStyle = self.colorScheme.barStyle
  }

  func applyNavigationBarStyle(_ navigationBar: UINavigationBar) {
    navigationBar.barStyle = self.colorScheme.barStyle
  }
}

// MARK: - Content size category observer

extension Theme {
  fileprivate func startObservingContentSizeCategory() {
    let notification = NSNotification.Name.UIContentSizeCategoryDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(notification:)), name: notification, object: nil)
  }

  fileprivate func stopObservingContentSizeCategory() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func contentSizeCategoryDidChange(notification: NSNotification) {
    self.systemFont.recalculateSizes()
    self.fontAwesomeFont.recalculateSizes()
  }
}
