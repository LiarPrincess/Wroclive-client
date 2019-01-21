// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout = LineSelectorHeaderViewConstants.Layout

public final class LineSelectorHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let textLabel = UILabel()

  public override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background

    self.textLabel.numberOfLines = 0
    self.textLabel.isUserInteractionEnabled = false

    self.addSubview(self.textLabel, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor, constant: Layout.topInset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])
  }

  // MARK: - Methods

  public func update(from viewModel: LineSelectorHeaderViewModel) {
    self.textLabel.attributedText = viewModel.text
  }
}
