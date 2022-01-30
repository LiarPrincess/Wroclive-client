// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = LineSelector.Constants.Header

internal final class LineSelectorHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let label = UILabel()

  override internal var alpha: CGFloat {
    get { return 1.0 }
    set {} // swiftlint:disable:this unused_setter_value
  }

  // MARK: - Init

  override internal init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  @available(*, unavailable)
  internal required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = ColorScheme.background

    self.label.numberOfLines = 0
    self.label.isUserInteractionEnabled = false
    self.label.adjustsFontForContentSizeCategory = true

    self.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.right.equalToSuperview()
    }
  }

  // MARK: - Methods

  internal func update(section: LineSelectorSection) {
    let text = Self.createText(section: section)
    self.label.attributedText = text
  }

  internal static func createText(section: LineSelectorSection) -> NSAttributedString {
    return NSAttributedString(
      string: section.name,
      attributes: Constants.textAttributes
    )
  }
}
