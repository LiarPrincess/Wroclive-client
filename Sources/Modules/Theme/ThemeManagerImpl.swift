//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import Foundation

extension Notification.Name {
  static let colorSchemeDidChange = Notification.Name("pl.kekapp.kek.colorSchemeChangedNotification")
}

// source: https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
class ThemeManagerImpl: ThemeManager {

  // MARK: - Properties

  fileprivate(set) var systemFont = SystemFont()
  fileprivate(set) var iconFont   = FontAwesomeFont()

  fileprivate(set) var colorScheme: ColorScheme

  // Mark - Init

  init() {
    self.colorScheme = ColorSchemeManager.load()
    self.startObservingContentSizeCategory()
    self.applyColorScheme()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  // Mark - Color scheme

  func setColorScheme(tint tintColor: TintColor, tram tramColor: VehicleColor, bus busColor: VehicleColor) {
    self.colorScheme = ColorScheme(tint: tintColor, tram: tramColor, bus: busColor)
    self.applyColorScheme()
    ColorSchemeManager.save(self.colorScheme)
    NotificationCenter.default.post(name: .colorSchemeDidChange, object: nil)
  }

  private func applyColorScheme() {
    UIApplication.shared.delegate?.window??.tintColor = self.colorScheme.tintColor.value
    UIWindow.appearance().tintColor                   = self.colorScheme.tintColor.value
    UIView.appearance().tintColor                     = self.colorScheme.tintColor.value

    // Make user location pin blue
    MKAnnotationView.appearance().tintColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)

    UINavigationBar.appearance().barStyle            = self.colorScheme.barStyle
    UINavigationBar.appearance().titleTextAttributes = self.textAttributes(for : .bodyBold)
    UIToolbar.appearance().barStyle                  = self.colorScheme.barStyle
  }

  // MARK: - Text attributes

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
