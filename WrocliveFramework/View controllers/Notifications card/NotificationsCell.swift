// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

// No insets in UITextView:
// https://www.pixeldock.com/blog/how-to-get-rid-of-the-padding-insets-in-an-uitextview/

private typealias Constants = NotificationsCard.Constants.Cell

public final class NotificationsCell: UITableViewCell {

  // MARK: - Properties

  private let userLabel = UILabel()
  private let dateLabel = UILabel()
  private let bodyTextView = UITextView()

  // MARK: - Init

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = ColorScheme.background

    self.userLabel.numberOfLines = 1
    self.userLabel.adjustsFontForContentSizeCategory = true
    self.userLabel.allowsDefaultTighteningForTruncation = false

    self.contentView.addSubview(self.userLabel)
    self.userLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }

    self.dateLabel.numberOfLines = 1
    self.dateLabel.adjustsFontForContentSizeCategory = true
    self.userLabel.allowsDefaultTighteningForTruncation = false
    self.dateLabel.setContentCompressionResistancePriority(900, for: .horizontal)

    self.contentView.addSubview(self.dateLabel)
    self.dateLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.equalTo(self.userLabel.snp.right)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }

    self.bodyTextView.isScrollEnabled = false
    self.bodyTextView.isUserInteractionEnabled = false
    self.bodyTextView.adjustsFontForContentSizeCategory = true
    self.bodyTextView.textContainerInset = .zero // Vertical
    self.bodyTextView.textContainer.lineFragmentPadding = 0 // Horizontal

    self.contentView.addSubview(self.bodyTextView)
    self.bodyTextView.snp.makeConstraints { make in
      make.top.equalTo(self.userLabel.snp.bottom).offset(Constants.Body.topMargin)
      make.top.equalTo(self.dateLabel.snp.bottom).offset(Constants.Body.topMargin)
      make.bottom.equalToSuperview().offset(-Constants.bottomInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }
  }

  // MARK: - Update

  public func update(viewModel: NotificationCellViewModel) {
    self.userLabel.attributedText = viewModel.userText
    self.dateLabel.attributedText = viewModel.dateText
    self.bodyTextView.attributedText = viewModel.bodyText
  }
}
