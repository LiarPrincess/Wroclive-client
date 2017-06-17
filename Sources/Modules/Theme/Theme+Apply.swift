//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

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

    case .bodyPrimary:
      label.font      = self.font.body
      label.textColor = self.colorScheme.primary
    }
  }

  func apply(toButton button: UIButton, style: ButtonStyle) {
    switch style {
    case .link:
      button.titleLabel?.font = self.font.body
      button.setTitleColor(self.colorScheme.primary, for: .normal)

    case .linkBold:
      button.titleLabel?.font = self.font.bodyBold
      button.setTitleColor(self.colorScheme.primary, for: .normal)

    case .templateImage:
      button.tintColor = self.colorScheme.primary
    }
  }

  func apply(toView view: UIView, style: ViewStyle) {
    switch style {
    case .alert:
      view.tintColor = self.colorScheme.primary

    case .cardPanel :
      view.backgroundColor = self.colorScheme.background
      view.roundTopCorners(radius: 8.0)

    case .cardPanelHeader:
      view.addBorder(at: .bottom)
    }
  }

  func apply(toSegmentedControl segmentedControl: UISegmentedControl) {
    segmentedControl.font      = self.font.body
    segmentedControl.tintColor = self.colorScheme.primary
  }

  func apply(toToolbar toolbar: UIToolbar) {
    toolbar.tintColor = self.colorScheme.primary
  }

}
