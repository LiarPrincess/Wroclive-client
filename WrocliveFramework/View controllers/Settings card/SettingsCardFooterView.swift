// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SettingsCard.Constants.Footer
private typealias Localization = Localizable.Settings

public final class SettingsCardFooterView: UIView {

  // MARK: - Properties

  private let label = UILabel()

  // MARK: - Init

  public init(device: DeviceManagerType) {
    let text = NSAttributedString(string: Localization.footer,
                                  attributes: Constants.textAttributes)

    let textHeight: CGFloat = {
      let textRect = CGSize(width: device.screenBounds.width,
                            height: CGFloat.infinity)
      let textSize = text.boundingRect(with: textRect,
                                       options: .usesLineFragmentOrigin,
                                       context: nil)
      return textSize.height + Constants.topOffset + Constants.bottomOffset
    }()

    let frame = CGRect(x: 0.0, y: 0.0, width: 1.0, height: textHeight)
    super.init(frame: frame)

    self.backgroundColor = ColorScheme.background

    self.label.attributedText = text
    self.label.numberOfLines = 0
    self.label.adjustsFontForContentSizeCategory = true

    self.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topOffset)
      make.bottom.equalToSuperview().offset(-Constants.bottomOffset)
      make.left.right.equalToSuperview()
    }
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
