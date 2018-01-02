//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = SearchPlaceholderViewConstants.Layout
private typealias TextStyles   = SearchPlaceholderViewConstants.TextStyles
private typealias Localization = Localizable.Search

class SearchPlaceholderView: UIView {

  // MARK: - Properties

  private let label   = UILabel()
  private let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  override var isHidden: Bool {
    didSet { self.updateAnimationState() }
  }

  // MARK: - Init

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.spinner)
    self.spinner.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    self.label.attributedText = NSAttributedString(string: Localization.loading, attributes: TextStyles.label)
    self.label.numberOfLines  = 0
    self.label.lineBreakMode  = .byWordWrapping

    self.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.equalTo(self.spinner.snp.bottom).offset(Layout.verticalSpacing)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private - Animation state

  private func updateAnimationState() {
    if self.isHidden { self.spinner.stopAnimating()  }
    else             { self.spinner.startAnimating() }
  }
}
