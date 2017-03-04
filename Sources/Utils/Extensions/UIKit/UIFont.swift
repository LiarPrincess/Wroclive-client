//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit


fileprivate typealias CustomFont = AvenirNext

//https://developer.apple.com/ios/human-interface-guidelines/visual-design/typography/
extension UIFont {

  class func customPreferredFont(forTextStyle style: UIFontTextStyle) -> UIFont {
    switch style {
    case UIFontTextStyle.headline:
      return self.boldCustomFont(ofSize: 18.0)

    case UIFontTextStyle.subheadline:
      return self.customFont(ofSize: 15.0)

    case UIFontTextStyle.body:
      return self.customFont(ofSize: 17.0)

    default:
      fatalError("Custom font style not specified for \(style)")
    }
  }

  fileprivate class func customFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: CustomFont.regular, size: fontSize)!
  }

  fileprivate class func boldCustomFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: CustomFont.demiBold, size: fontSize)!
  }

  fileprivate class func italicCustomFont(ofSize fontSize: CGFloat) -> UIFont {
    return UIFont(name: CustomFont.italic, size: fontSize)!
  }

}

//MARK: - Avenir

struct Avenir {

  static let familyName = "Avenir"

  static let Black =        "Avenir-Black"
  static let BlackOblique = "Avenir-BlackOblique"

  static let Heavy =        "Avenir-Heavy"
  static let HeavyOblique = "Avenir-HeavyOblique"

  static let Medium =        "Avenir-Medium"
  static let MediumOblique = "Avenir-MediumOblique"

  static let Roman =   "Avenir-Roman"
  static let Oblique = "Avenir-Oblique"

  static let Book =        "Avenir-Book"
  static let BookOblique = "Avenir-BookOblique"

  static let Light =        "Avenir-Light"
  static let LightOblique = "Avenir-LightOblique"

}

//MARK: - Avenir Next

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
