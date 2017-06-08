//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AvenirFontProvider: FontProviderProtocol {
  var headline:    UIFont
  var subheadline: UIFont
  var body:        UIFont

  public init() {
    self.headline    = UIFont()
    self.subheadline = UIFont()
    self.body        = UIFont()
    self.recalculateSizes()
  }

  func recalculateSizes() {
   // 14pt -> 17pt -> 23pt
    let defaultFontSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
    self.headline    = self.customFontBold(ofSize: defaultFontSize + 1.0)
    self.subheadline = self.customFontBold(ofSize: defaultFontSize + 1.0)
    self.body        = self.customFont(ofSize: defaultFontSize - 1.0)
  }

  private func customFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.regular, size: fontSize)!
  }

  private func customFontBold(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: AvenirNext.demiBold, size: fontSize)!
  }
}

//MARK: - Font

extension AvenirFontProvider {

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
