//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

let NotificationContentSizeCategoryChanged: String = "NotificationContentSizeCategoryChanged"
let NotificationColorSchemeChanged:         String = "NotificationColorSchemeChanged"

// source: https://alttab.co/blog/2016/06/21/theming-ios-applications/
class Theme {

  // Mark - Singleton

  static let current = Theme(colorScheme: .light, font: AvenirFontProvider())

  // Mark - Properties

  var colorScheme: ColorScheme {
    didSet { self.notifyColorSchemeChanged() }
  }

  var font: FontProvider {
    didSet { self.notifyContentSizeCategoryChanged() }
  }

  // Mark - Init

  private init(colorScheme: ColorScheme, font: FontProvider) {
    self.colorScheme = colorScheme
    self.font        = font
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  //MARK: - Notifications

  func notifyContentSizeCategoryChanged() {
    let name = NSNotification.Name(rawValue: NotificationContentSizeCategoryChanged)
    NotificationCenter.default.post(Notification(name: name, object: nil))
  }

  func notifyColorSchemeChanged() {
    let name = NSNotification.Name(rawValue: NotificationColorSchemeChanged)
    NotificationCenter.default.post(Notification(name: name, object: nil))
  }

}

//MARK: - Content size category observer

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
    self.notifyContentSizeCategoryChanged()
  }
}
