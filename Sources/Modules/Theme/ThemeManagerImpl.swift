//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class ThemeManagerImpl: ThemeManager {

  // Mark - Init

  init() {
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  // Mark - Color scheme

  fileprivate(set) var colorScheme = ColorScheme(tint: .red, bus: .red, tram: .blue)

  func setColorScheme(tint tintColor: TintColor, bus busColor: VehicleColor, tram tramColor: VehicleColor) {
    if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window {
      window?.tintColor = tintColor.value
    }

    self.colorScheme = ColorScheme(tint: tintColor, bus: busColor, tram: tramColor)
  }

  // MARK: - Text attributes

  fileprivate(set) var systemFont = SystemFont()
  fileprivate(set) var iconFont   = FontAwesomeFont()

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType,
                      alignment:     NSTextAlignment,
                      lineSpacing:   CGFloat,
                      color:         TextColor) -> [String:Any] {
    let colorValue = self.colorValue(color)
    return self.textAttributes(for: textStyle, fontType: fontType, alignment: alignment, lineSpacing: lineSpacing, color: colorValue)
  }

  func textAttributes(for textStyle: TextStyle,
                      fontType:      FontType,
                      alignment:     NSTextAlignment,
                      lineSpacing:   CGFloat,
                      color:         UIColor) -> [String:Any] {
    return [
      NSFontAttributeName:            self.fontValue(fontType, textStyle),
      NSKernAttributeName:            self.trackingValue(fontType, textStyle),
      NSForegroundColorAttributeName: color,
      NSParagraphStyleAttributeName:  self.paragraphStyle(alignment, lineSpacing)
    ]
  }

  private func colorValue(_ color: TextColor) -> UIColor {
    switch color {
    case .background:       return self.colorScheme.background
    case .backgroundAccent: return self.colorScheme.backgroundAccent
    case .text:             return self.colorScheme.text
    case .tint:             return self.colorScheme.tintColor.value
    case .bus:              return self.colorScheme.busColor.value
    case .tram:             return self.colorScheme.tramColor.value
    }
  }

  private func font(ofType fontType: FontType) -> Font {
    return fontType == .icon ? self.iconFont : self.systemFont
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

  // MARK: - Card panel

  func applyCardPanelStyle(_ view: UIView) {
    view.backgroundColor = self.colorScheme.background
    view.roundTopCorners(radius: 8.0)
  }

  func applyCardPanelHeaderStyle(_ view: UIView) {
    view.addBorder(at: .bottom)
    view.setContentHuggingPriority(900, for: .vertical)
  }

  // MARK: - Navigation

  func applyNavigationBarStyle(_ navigationBar: UINavigationBar) {
    navigationBar.barStyle = self.colorScheme.barStyle
  }

  func applyToolbarStyle(_ toolbar: UIToolbar) {
    toolbar.barStyle = self.colorScheme.barStyle
  }
}

// MARK: - Content size category observer

extension ThemeManagerImpl {
  fileprivate func startObservingContentSizeCategory() {
    let notification = NSNotification.Name.UIContentSizeCategoryDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(notification:)), name: notification, object: nil)
  }

  fileprivate func stopObservingContentSizeCategory() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func contentSizeCategoryDidChange(notification: NSNotification) {
    self.systemFont.recalculateSizes()
    self.iconFont.recalculateSizes()
  }
}
