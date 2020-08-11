// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SettingsCard.Constants.SectionHeader

public final class SettingsSectionHeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  private let titleLabel = UILabel()

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

    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      // We do not need:
      // - bottom - we have 'tableView(_:heightForHeaderInSection:)' for this
      // - right - it will automatically resize to required width
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }
  }

  public func update(section: SettingsSection) {
    self.titleLabel.attributedText = NSAttributedString(
      string: section.kind.text,
      attributes: Constants.titleAttributes
    )
  }
}
