//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

let NotificationDynamicFontChanged: String = "NotificationDynamicFontChanged"

class FontManager {

  //MARK: - Singleton

  static let instance = FontManager()

  //MARK: - Properties

  private(set) var navigationBar:     UIFont!
  private(set) var navigationBarItem: UIFont!

  private(set) var lineSelectionSectionHeader:    UIFont!
  private(set) var lineSelectionCellContent:      UIFont!
  private(set) var lineSelectionLineTypeSelector: UIFont!

  private(set) var bookmarkCellTitle:          UIFont!
  private(set) var bookmarkCellContent:        UIFont!
  private(set) var bookmarkPlaceholderTitle:   UIFont!
  private(set) var bookmarkPlaceholderContent: UIFont!

  //MARK: - Init

  private init() {
    self.refreshFonts()
    self.startObservingContentSizeCategory()
  }

  deinit {
    self.stopObservingContentSizeCategory()
  }

  //MARK: - Methods

  fileprivate func refreshFonts() {
    let defaultStandardFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize   // 14pt -> 17pt -> 23pt
    //let defaultMediumFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote).pointSize // 12pt -> 13pt -> 19pt
    //let defaultSmallFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption2).pointSize  // 11pt -> 11pt -> 17pt

    self.navigationBar     = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.navigationBarItem = self.customFont(ofSize: defaultStandardFontSize)

    self.lineSelectionSectionHeader    = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.lineSelectionCellContent      = self.customFont(ofSize: defaultStandardFontSize - 1.0)
    self.lineSelectionLineTypeSelector = self.customFont(ofSize: defaultStandardFontSize - 1.0)

    self.bookmarkCellTitle          = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.bookmarkCellContent        = self.customFont(ofSize: defaultStandardFontSize - 1.0)
    self.bookmarkPlaceholderTitle   = self.customFontBold(ofSize: defaultStandardFontSize + 1.0)
    self.bookmarkPlaceholderContent = self.customFont(ofSize: defaultStandardFontSize) // caps?
  }

  private func customFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.regular, size: fontSize)!
  }

  private func customFontBold(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.demiBold, size: fontSize)!
  }

}

//MARK: - Content size category observer

extension FontManager {

  fileprivate func startObservingContentSizeCategory() {
    let notification = NSNotification.Name.UIContentSizeCategoryDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange(notification:)), name: notification, object: nil)
  }

  fileprivate func stopObservingContentSizeCategory() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func contentSizeCategoryDidChange(notification: NSNotification) {
    refreshFonts()

    let name = NSNotification.Name(rawValue: NotificationDynamicFontChanged)
    NotificationCenter.default.post(Notification(name: name, object: nil))
  }
}

//MARK: - Avenir Next

extension FontManager {

  //https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/
  fileprivate struct AvenirNext {

    static let familyName =  "Avenir Next"

    static let heavy =       "AvenirNext-Heavy"
    static let heavyItalic = "AvenirNext-HeavyItalic"

    static let bold =        "AvenirNext-Bold"
    static let boldItalic =  "AvenirNext-BoldItalic"

    static let demiBold =       "AvenirNext-DemiBold"
    static let demiBoldItalic = "AvenirNext-DemiBoldItalic"

    static let medium =         "AvenirNext-Medium"
    static let mediumItalic =   "AvenirNext-MediumItalic"

    static let regular =        "AvenirNext-Regular"
    static let italic =         "AvenirNext-Italic"

    static let ultraLight =       "AvenirNext-UltraLight"
    static let ultraLightItalic = "AvenirNext-UltraLightItalic"
    
  }

}
