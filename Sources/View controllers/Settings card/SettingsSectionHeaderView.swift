// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout = SettingsSectionHeaderViewConstants.Layout

class SettingsSectionHeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  let titleLabel = UILabel()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.contentView.backgroundColor = Theme.colors.background

    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
  }
}
