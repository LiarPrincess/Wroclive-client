//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

extension Theme {

  func apply(toLabel label: UILabel, style: TextStyle) {
    switch style {
    case .headline:
      label.font      = self.font.headline
      label.textColor = self.colorScheme.text

    case .subheadline:
      label.font      = self.font.subheadline
      label.textColor = self.colorScheme.text

    case .body:
      label.font      = self.font.body
      label.textColor = self.colorScheme.text
    }
  }

  func apply(toButton button: UIButton, style: ButtonStyle) {

  }

  func apply(toView view: UIView, style: ViewStyle) {
    
  }
  
}
