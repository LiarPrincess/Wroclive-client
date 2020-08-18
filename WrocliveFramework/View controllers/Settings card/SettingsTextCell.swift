// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SettingsCard.Constants.Cell

/// Cell that contains only text.
public final class SettingsTextCell: UITableViewCell {

  // MARK: - Properties

  private let bottomBorder = UIView()
  private var isBottomBorderVisible = true
  private var hasAddedBottomBorderHeightConstraints = false

  override public var alpha: CGFloat {
    get { return 1.0 }
    set {} // swiftlint:disable:this unused_setter_value
  }

  // MARK: - Init

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = ColorScheme.background

    self.textLabel?.adjustsFontForContentSizeCategory = true

    self.bottomBorder.backgroundColor = ColorScheme.accent

    self.addSubview(self.bottomBorder)
    self.bottomBorder.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(Constants.BottomBorder.leftInset)
      make.right.equalToSuperview()
    }
  }

  // MARK: - Overriden

  override public func layoutSubviews() {
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
      attributes: Constants.textAttributes
    )

    if let imageView = self.imageView {
      imageView.image = kind.image?.value
    }

    self.isBottomBorderVisible = !isLastCellInSection
    if self.isBottomBorderVisible && !self.hasAddedBottomBorderHeightConstraints {
      self.bottomBorder.snp.makeConstraints { make in
        make.height.equalTo(1.0 / device.screenScale)
      }

      self.hasAddedBottomBorderHeightConstraints = true
    }
  }
}
