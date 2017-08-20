//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class Theme {

  // Mark - Properties

  fileprivate(set) var colorScheme: ColorScheme
  fileprivate(set) var font:        FontProvider

  // Mark - Init

  init(colorScheme: ColorScheme, font: FontProvider) {
    self.colorScheme = colorScheme
    self.font        = font
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  // MARK: - Text attributes

  func textAttributes(for textStyle: TextStyle,
                      alignment:     NSTextAlignment = .natural,
                      lineSpacing:   CGFloat         = 0.0,
                      color:         Color           = Color.text
  ) -> [String:Any] {
    return [
      NSFontAttributeName:            self.fontValue(textStyle),
      NSKernAttributeName:            self.trackingValue(textStyle),
      NSForegroundColorAttributeName: self.colorValue(color),
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

  private func fontValue(_ textStyle: TextStyle) -> UIFont {
    switch textStyle {
    case .headline:    return self.font.headline
    case .subheadline: return self.font.subheadline
    case .body:        return self.font.body
    case .bodyBold:    return self.font.bodyBold
    case .caption:     return self.font.caption
    }
  }

  private func trackingValue(_ textStyle: TextStyle) -> CGFloat {
    switch textStyle {
    case .headline:    return self.font.headlineTracking
    case .subheadline: return self.font.subheadlineTracking
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
    self.font.recalculateSizes()
  }
}
