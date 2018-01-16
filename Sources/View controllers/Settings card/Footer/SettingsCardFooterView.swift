//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = SettingsCardFooterConstants.Layout
private typealias TextStyles   = SettingsCardFooterConstants.TextStyles
private typealias Localization = Localizable.Configuration

class SettingsCardFooterView: UIView {

  // MARK: - Properties

  private let label = UILabel()

  // MARK: - Init

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    let text       = NSAttributedString(string: Localization.footer, attributes: TextStyles.text)
    let textHeight = SettingsCardFooterView.calculateMinHeight(text)

    super.init(frame: CGRect(x: 0.0, y: 0.0, width: 1.0, height: textHeight))

    self.label.attributedText = text
    self.label.numberOfLines  = 0

    self.addSubview(self.label)
    label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topOffset)
      make.left.right.bottom.equalToSuperview()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private static func calculateMinHeight(_ text: NSAttributedString) -> CGFloat {
    let textRect = CGSize(width: Managers.device.screenBounds.width, height: CGFloat.infinity)
    let textSize = text.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)
    return textSize.height + Layout.topOffset + Layout.bottomOffset
  }
}
