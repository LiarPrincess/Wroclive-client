//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

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

    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.contentLabel.attributedText = self.createContentText()
    self.contentLabel.numberOfLines  = 0
    self.contentLabel.lineBreakMode  = .byWordWrapping

    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Layout.Content.topMargin)
      make.left.bottom.right.equalToSuperview()
    }
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
