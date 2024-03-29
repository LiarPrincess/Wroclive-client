// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SettingsCard.Constants.SectionHeader

public final class SettingsSectionHeaderView: UITableViewHeaderFooterView {

  // MARK: - Properties

  private let label = UILabel()

  override public var alpha: CGFloat {
    get { return 1.0 }
    set {} // swiftlint:disable:this unused_setter_value
  }

  // MARK: - Init

  override public init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.contentView.backgroundColor = ColorScheme.background

    self.label.adjustsFontForContentSizeCategory = true

    self.contentView.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      // We do not need:
      // - bottom - we have 'tableView(_:heightForHeaderInSection:)' for this
      // - right - it will automatically resize to required width
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }
  }

  public func update(section: SettingsSection) {
    self.label.attributedText = NSAttributedString(
      string: section.text,
      attributes: Constants.titleAttributes
    )
  }
}
