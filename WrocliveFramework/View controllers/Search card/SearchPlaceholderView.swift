// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout       = SearchPlaceholderViewConstants.Layout
private typealias TextStyles   = SearchPlaceholderViewConstants.TextStyles
private typealias Localization = Localizable.Search

public final class SearchPlaceholderView: UIView {

  // MARK: - Properties

  private let label   = UILabel()
  private let spinner = UIActivityIndicatorView(style: .gray)

  public override var isHidden: Bool {
    didSet { self.updateAnimationState() }
  }

  // MARK: - Init

  public convenience init() {
    self.init(frame: .zero)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.spinner)
    self.spinner.snp.makeConstraints { make in
      make.top.centerX.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    self.label.attributedText = NSAttributedString(string: Localization.loading, attributes: TextStyles.label)
    self.label.numberOfLines  = 0
    self.label.lineBreakMode  = .byWordWrapping

    self.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.equalTo(self.spinner.snp.bottom).offset(Layout.verticalSpacing)
      make.bottom.left.right.equalToSuperview()
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private - Animation state

  private func updateAnimationState() {
    if self.isHidden { self.spinner.stopAnimating()  }
    else             { self.spinner.startAnimating() }
  }
}
