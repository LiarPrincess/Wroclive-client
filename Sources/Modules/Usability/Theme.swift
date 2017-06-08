//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

let NotificationDynamicFontChanged: String = "NotificationDynamicFontChanged"

class Theme {

  //MARK: - Singleton

  static let current = Theme()

  //MARK: - Properties

  private(set) var font: FontProviderProtocol
  //color scheme

  //MARK: - Init

  private init() {
    self.font = AvenirFontProvider()
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
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

    let name = NSNotification.Name(rawValue: NotificationDynamicFontChanged)
    NotificationCenter.default.post(Notification(name: name, object: nil))
  }
}
