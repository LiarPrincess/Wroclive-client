// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout       = BookmarksPlaceholderViewConstants.Layout
private typealias TextStyles   = BookmarksPlaceholderViewConstants.TextStyles
private typealias Localization = Localizable.Bookmarks.Placeholder

class BookmarksPlaceholderView: UIView {

  // MARK: - Properties

  private let titleLabel   = UILabel()
  private let contentLabel = UILabel()

  // MARK: - Init

  convenience init() {
    self.init(frame: .zero)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.titleLabel.attributedText = self.createTitleText()
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.addSubview(self.titleLabel, constraints: [
      self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      self.titleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
      self.titleLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
    ])

    self.contentLabel.attributedText = self.createContentText()
    self.contentLabel.numberOfLines  = 0
    self.contentLabel.lineBreakMode  = .byWordWrapping

    self.addSubview(self.contentLabel, constraints: [
      self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Content.topMargin),
      self.contentLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
      self.contentLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
      self.contentLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
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
