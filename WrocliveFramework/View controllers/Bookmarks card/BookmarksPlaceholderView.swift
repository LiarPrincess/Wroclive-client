// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout       = BookmarksPlaceholderViewConstants.Layout
private typealias TextStyles   = BookmarksPlaceholderViewConstants.TextStyles
private typealias Localization = Localizable.Bookmarks.Placeholder

public final class BookmarksPlaceholderView: UIView {

  // MARK: - Properties

  private let titleLabel   = UILabel()
  private let contentLabel = UILabel()

  // MARK: - Init

  public convenience init() {
    self.init(frame: .zero)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.titleLabel.attributedText = self.createTitleText()
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping
    self.titleLabel.adjustsFontForContentSizeCategory = true

    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.contentLabel.attributedText = self.createContentText()
    self.contentLabel.numberOfLines  = 0
    self.contentLabel.lineBreakMode  = .byWordWrapping
    self.contentLabel.adjustsFontForContentSizeCategory = true

    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Layout.Content.topMargin)
      make.bottom.left.right.equalToSuperview()
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func createTitleText() -> NSAttributedString {
    return NSAttributedString(string: Localization.title, attributes: TextStyles.title)
  }

  private func createContentText() -> NSAttributedString {
    let content = Localization.content
    let textAttributes = TextStyles.Content.text
    let iconAttributes = TextStyles.Content.icon

    let starReplacement = TextReplacement("<star>", NSAttributedString(string: "\u{f006}", attributes: iconAttributes))

    return NSAttributedString(string: content, attributes: textAttributes)
      .withReplacements([starReplacement])
  }
}
