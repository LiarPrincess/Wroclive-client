// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout       = SearchPlaceholderViewConstants.Layout
private typealias TextStyles   = SearchPlaceholderViewConstants.TextStyles
private typealias Localization = Localizable.Search

public final class SearchPlaceholderView: UIView {

  // MARK: - Properties

  private let label   = UILabel()
  private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  public override var isHidden: Bool {
    didSet { self.updateAnimationState() }
  }

  // MARK: - Init

  public convenience init() {
    self.init(frame: .zero)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.spinner, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor),
      make(\UIView.centerXAnchor, equalToSuperview: \UIView.centerXAnchor)
    ])

    self.label.attributedText = NSAttributedString(string: Localization.loading, attributes: TextStyles.label)
    self.label.numberOfLines  = 0
    self.label.lineBreakMode  = .byWordWrapping

    self.addSubview(self.label, constraints: [
      make(\UIView.topAnchor, equalTo: self.spinner.bottomAnchor, constant: Layout.verticalSpacing),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])
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
