// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout       = SettingsCardFooterConstants.Layout
private typealias TextStyles   = SettingsCardFooterConstants.TextStyles
private typealias Localization = Localizable.Settings

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
    let textRect = CGSize(width: AppEnvironment.device.screenBounds.width, height: CGFloat.infinity)
    let textSize = text.boundingRect(with: textRect, options: .usesLineFragmentOrigin, context: nil)
    return textSize.height + Layout.topOffset + Layout.bottomOffset
  }
}
