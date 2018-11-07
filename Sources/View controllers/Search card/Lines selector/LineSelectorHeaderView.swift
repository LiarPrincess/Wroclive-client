// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout = LineSelectorHeaderViewConstants.Layout

class LineSelectorHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let textLabel = UILabel()

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background

    self.textLabel.numberOfLines = 0
    self.textLabel.isUserInteractionEnabled = false

    self.addSubview(self.textLabel)
    self.textLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.right.equalToSuperview()
    }
  }

  // MARK: - Methods

  func update(from viewModel: LineSelectorHeaderViewModel) {
    self.textLabel.attributedText = viewModel.text
  }
}
