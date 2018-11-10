// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout = SettingsTextCellConstants.Layout

class SettingsTextCell: UITableViewCell {

  // MARK: - Properties

  var isBottomBorderVisible: Bool = true
  private let bottomBorder = UIView()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background

    self.bottomBorder.backgroundColor = Theme.colors.accentLight

    self.addSubview(self.bottomBorder, constraints: [
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.heightAnchor, equalToConstant: 1.0 / AppEnvironment.device.screenScale),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.BottomBorder.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])
  }

  // MARK: - Overriden

  override func layoutSubviews() {
    super.layoutSubviews()
    self.bottomBorder.isHidden = !self.isBottomBorderVisible
  }
}
