// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = BookmarksCard.Constants.Placeholder
private typealias Localization = Localizable.Bookmarks.Placeholder

public final class BookmarksPlaceholderView: UIView {

  // MARK: - Properties

  private let titleLabel = UILabel()
  private let contentLabel = UILabel()

  // MARK: - Init

  public convenience init() {
    self.init(frame: .zero)
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)

    self.titleLabel.attributedText = self.createTitleText()
    self.titleLabel.numberOfLines = 0
    self.titleLabel.lineBreakMode = .byWordWrapping
    self.titleLabel.adjustsFontForContentSizeCategory = true

    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.contentLabel.attributedText = self.createContentText()
    self.contentLabel.numberOfLines = 0
    self.contentLabel.lineBreakMode = .byWordWrapping
    self.contentLabel.adjustsFontForContentSizeCategory = true

    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.topMargin)
      make.bottom.left.right.equalToSuperview()
    }
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private

  private func createTitleText() -> NSAttributedString {
    let string = Localization.title
    let attributes = Constants.Title.attributes
    return NSAttributedString(string: string, attributes: attributes)
  }

  private func createContentText() -> NSAttributedString {
    let heartAttachment = self.createHeartAttachment()
    let heartAttributedString = NSAttributedString(attachment: heartAttachment)
    let heartReplacement = TextReplacement("<heart>", heartAttributedString)

    return NSAttributedString(
      string: Localization.content,
      attributes: Constants.Content.textAttributes
    ).withReplacements([heartReplacement])
  }

  private func createHeartAttachment() -> NSTextAttachment {
    let image = ImageAsset.bookmarksPlaceholderHeart.value
    let imageSize = image.size

    let result = NSTextAttachment()
    result.image = image
    result.adjustsImageSizeForAccessibilityContentSizeCategory = true

    // Make it a little bit lower to make it Y centered (more or less).
    // (and yes there is a difference between 1.0, 1.5 and 2.0).
    result.bounds = CGRect(
      x: 0.0,
      y: -1.5,
      width: imageSize.width,
      height: imageSize.height
    )

    return result
  }
}
