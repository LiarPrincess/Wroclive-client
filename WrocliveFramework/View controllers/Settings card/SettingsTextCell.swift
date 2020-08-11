// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout = SettingsTextCellConstants.Layout
private typealias TextStyles = SettingsCardConstants.TextStyles

/// Cell that contains only text.
public final class SettingsTextCell: UITableViewCell {

  // MARK: - Properties

  private let bottomBorder = UIView()
  private var isBottomBorderVisible = true
  private var hasAddedBottomBorderHeightConstraints = false

  public override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background

    self.bottomBorder.backgroundColor = Theme.colors.accentLight

    self.addSubview(self.bottomBorder)
    self.bottomBorder.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(Layout.BottomBorder.leftInset)
      make.right.equalToSuperview()
    }
  }

  // MARK: - Overriden

  public override func layoutSubviews() {
    super.layoutSubviews()
    self.bottomBorder.isHidden = !self.isBottomBorderVisible
  }

  // MARK: - Update

  public func update(kind: SettingsSection.CellKind,
                     isLastCellInSection: Bool,
                     device: DeviceManagerType) {
    // 'accessoryType' may depend on 'kind'
    self.accessoryType = .disclosureIndicator

    self.textLabel?.attributedText = NSAttributedString(
      string: kind.text,
      attributes: TextStyles.cellText
    )

    self.isBottomBorderVisible = !isLastCellInSection
    if self.isBottomBorderVisible && !self.hasAddedBottomBorderHeightConstraints {
      self.bottomBorder.snp.makeConstraints { make in
        make.height.equalTo(1.0 / device.screenScale)
      }

      self.hasAddedBottomBorderHeightConstraints = true
    }
  }
}
