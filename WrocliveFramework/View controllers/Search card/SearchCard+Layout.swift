// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Localization = Localizable.Search

extension SearchCard {

  internal func initLayout() {
    self.view.backgroundColor = ColorScheme.background
    self.initHeader()
    self.initLinesSelector()
    self.initPlaceholder()
  }

  // MARK: - Header

  // swiftlint:disable:next function_body_length
  private func initHeader() {
    let device = self.environment.device
    self.headerView.contentView.addBottomBorder(device: device)
    self.headerView.setContentHuggingPriority(900, for: .vertical)

    self.view.addSubview(self.headerView)
    self.headerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.initTitleLabel(text: Localization.title,
                        attributes: Constants.Header.Title.attributes)

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.Header.Title.topOffset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }

    self.initBookmarkButton(image: ImageAsset.searchHeart,
                            color: ColorScheme.tint,
                            insets: Constants.Header.Bookmark.insets,
                            action: #selector(didPressBookmarkButton))

    self.headerView.contentView.addSubview(self.bookmarkButton)
    self.bookmarkButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.titleLabel.snp.lastBaseline)
      make.left.equalTo(self.titleLabel.snp.right)
    }

    self.initSearchLabel(text: Localization.search,
                         attributes: Constants.Header.Search.attributes,
                         insets: Constants.Header.Search.insets,
                         action: #selector(didPressSearchButton))

    self.headerView.contentView.addSubview(self.searchButton)
    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    // 'self.lineTypeSelector' starts here

    self.headerView.contentView.addSubview(self.lineTypeSelector)
    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.Header.LineType.topOffset)
      make.bottom.equalToSuperview().offset(-Constants.Header.LineType.bottomOffset)
      make.height.equalTo(LineTypeSegmentedControl.Constants.nominalHeight)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }
  }

  private func initTitleLabel(text: String,
                              attributes: TextAttributes) {
    self.titleLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    self.titleLabel.adjustsFontForContentSizeCategory = true
  }

  private func initBookmarkButton(image: ImageAsset,
                                  color: UIColor,
                                  insets: UIEdgeInsets,
                                  action: Selector) {
    self.bookmarkButton.setImage(image.value, for: .normal)
    self.bookmarkButton.tintColor = color
    self.bookmarkButton.contentEdgeInsets = insets
    self.bookmarkButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
    self.bookmarkButton.addTarget(self, action: action, for: .touchUpInside)
  }

  private func initSearchLabel(text: String,
                               attributes: TextAttributes,
                               insets: UIEdgeInsets,
                               action: Selector) {
    let attributedText = NSAttributedString(string: text, attributes: attributes)
    self.searchButton.setAttributedTitle(attributedText, for: .normal)
    self.searchButton.contentEdgeInsets = insets
    self.searchButton.titleLabel?.adjustsFontForContentSizeCategory = true
    self.searchButton.addTarget(self, action: action, for: .touchUpInside)
  }

  // MARK: - Lines selector

  private func initLinesSelector() {
    self.addChild(self.lineSelector)
    self.view.insertSubview(self.lineSelector.view, belowSubview: self.headerView)
    self.lineSelector.view.snp.makeConstraints { $0.edges.equalToSuperview() }

    self.lineSelector.didMove(toParent: self)
  }

  // MARK: - Placeholder

  private func initPlaceholder() {
    let container = UIView()

    self.view.insertSubview(container, belowSubview: self.lineSelector.view)
    container.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.contentView.snp.bottom)
      make.bottom.left.right.equalToSuperview()
    }

    container.addSubview(self.placeholderView)
    self.placeholderView.snp.makeConstraints { make in
      make.bottom.equalTo(container.snp.centerY)
      make.left.equalToSuperview().offset(Constants.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Constants.Placeholder.rightInset)
    }
  }
}
