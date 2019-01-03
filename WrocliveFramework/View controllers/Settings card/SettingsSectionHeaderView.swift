// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout = SettingsSectionHeaderViewConstants.Layout

public final class SettingsSectionHeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  public let titleLabel = UILabel()

  public override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.contentView.backgroundColor = Theme.colors.background

    self.contentView.addSubview(self.titleLabel, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor, constant: Layout.topInset),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor, constant: -Layout.bottomInset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.rightInset)
    ])
  }
}
