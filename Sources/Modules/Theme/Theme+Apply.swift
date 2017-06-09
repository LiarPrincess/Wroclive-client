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
    }
  }

  func apply(toView view: UIView, style: ViewStyle) {
    switch style {
    case .background:
      view.backgroundColor = self.colorScheme.background

    case .cardPanel :
      view.backgroundColor = self.colorScheme.background
      view.roundTopCorners(radius: 8.0)

    case .cardPanelHeader:
      view.addBorder(at: .bottom)

      let promptView = UIView()
      promptView.layer.cornerRadius = 2.0
      promptView.backgroundColor    = UIColor(white: 0.8, alpha: 1.0)
      view.addSubview(promptView)

      promptView.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(8.0)
        make.centerX.equalToSuperview()
        make.width.equalTo(35.0)
        make.height.equalTo(4.0)
      }
    }
  }
  
}
