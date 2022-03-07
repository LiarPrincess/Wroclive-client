// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

public typealias SearchPlaceholderView = LoadingView

/// Simple view with an activity indicator (spinner) and a 'Loading' label below.
///
/// Hide it to stop animation.
public final class LoadingView: UIView {

  private enum Constants {
    fileprivate static let verticalSpacing = CGFloat(8.0)
    fileprivate static let textAttributes = TextAttributes(style: .body,
                                                           alignment: .center)
  }

  // MARK: - Properties

  private let label = UILabel()
  private let spinner = UIActivityIndicatorView(style: .gray)

  override public var isHidden: Bool {
    didSet { self.updateAnimationState() }
  }

  // MARK: - Init

  public convenience init() {
    self.init(frame: .zero)
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.spinner)
    self.spinner.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
    }

    self.label.attributedText = NSAttributedString(
      string: Localizable.Loading.text,
      attributes: Constants.textAttributes
    )

    self.label.numberOfLines = 0
    self.label.lineBreakMode = .byWordWrapping
    self.label.adjustsFontForContentSizeCategory = true

    self.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.equalTo(self.spinner.snp.bottom).offset(Constants.verticalSpacing)
      make.bottom.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Animation state

  private func updateAnimationState() {
    if self.isHidden {
      self.spinner.stopAnimating()
    } else {
      self.spinner.startAnimating()
    }
  }
}
