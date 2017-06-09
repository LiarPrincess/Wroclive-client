//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

//MARK: - Text

extension UILabel {
  func setStyle(_ style: TextStyle) {
    Theme.current.apply(toLabel: self, style: style)
  }
}

//MARK: - Button

extension UIButton {
  func setStyle(_ style: ButtonStyle) {
    Theme.current.apply(toButton: self, style: style)
  }
}

//MARK: - View

extension UIView {
  func setStyle(_ style: ViewStyle) {
    Theme.current.apply(toView: self, style: style)
  }
}
