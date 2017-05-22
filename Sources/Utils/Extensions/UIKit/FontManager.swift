//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

let NotificationDynamicFontChanged: String = "NotificationDynamicFontChanged"

class FontManager {

  //MARK: - Singleton

  static let instance = FontManager()

  //MARK: - Properties

  var navigationBar: UIFont!
  var navigationBarItem: UIFont!

  var bookmarkCellTitle: UIFont!
  var bookmarkCellContent: UIFont!

  //MARK: - Init

  private init() {
    self.refreshFonts()
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  //MARK: - Observer

  private func startObservingContentSizeCategory() {
    let notification = NSNotification.Name.UIContentSizeCategoryDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(notification:)), name: notification, object: nil)
  }

  private func stopObservingContentSizeCategory() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func contentSizeCategoryDidChange(notification: NSNotification) {
    refreshFonts()

    let name = NSNotification.Name(rawValue: NotificationDynamicFontChanged)
    NotificationCenter.default.post(Notification(name: name, object: nil))
  }

  //MARK: - Methods

  private func refreshFonts() {
    let defaultStandardFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize   // 14pt -> 17pt -> 23pt
    //let defaultMediumFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).pointSize // 12pt -> 13pt -> 19pt
    //let defaultSmallFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption2).pointSize  // 11pt -> 11pt -> 17pt

    self.navigationBar = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.navigationBarItem = self.customFont(ofSize: defaultStandardFontSize)

    self.bookmarkCellTitle = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.bookmarkCellContent = self.customFont(ofSize: defaultStandardFontSize - 1.0)
  }

  private func customFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.regular, size: fontSize)!
  }

  private func customFontBold(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.demiBold, size: fontSize)!
  }

}

//MARK: - Avenir Next

extension FontManager {

  //https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/
  fileprivate struct AvenirNext {

    static let familyName = "Avenir Next"

    static let heavy =       "AvenirNext-Heavy"
    static let heavyItalic = "AvenirNext-HeavyItalic"

    static let bold =       "AvenirNext-Bold"
    static let boldItalic = "AvenirNext-BoldItalic"

    static let demiBold =       "AvenirNext-DemiBold"
    static let demiBoldItalic = "AvenirNext-DemiBoldItalic"

    static let medium =       "AvenirNext-Medium"
    static let mediumItalic = "AvenirNext-MediumItalic"

    static let regular = "AvenirNext-Regular"
    static let italic =  "AvenirNext-Italic"

    static let ultraLight =       "AvenirNext-UltraLight"
    static let ultraLightItalic = "AvenirNext-UltraLightItalic"
    
  }

}
