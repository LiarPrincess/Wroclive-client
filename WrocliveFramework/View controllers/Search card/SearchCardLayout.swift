// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = SearchCardConstants
private typealias Localization = Localizable.Search

internal extension SearchCard {

  func initLayout() {
    self.view.backgroundColor = Theme.colors.background
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

    self.titleLabel.attributedText = NSAttributedString(
      string: Localization.title,
      attributes: Constants.Header.Title.attributes
    )
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.Header.Title.topOffset)
      make.left.equalToSuperview().offset(Constants.leftInset)
    }

    let bookmarkImage = StyleKit.drawStarTemplateImage(size: Constants.Header.Bookmark.size)
    self.bookmarkButton.setImage(bookmarkImage, for: .normal)
    self.bookmarkButton.tintColor = Theme.colors.tint
    self.bookmarkButton.contentEdgeInsets = Constants.Header.Bookmark.insets
    self.bookmarkButton.addTarget(self,
                                  action: #selector(didPressBookmarkButton),
                                  for: .touchUpInside)

    self.headerView.contentView.addSubview(self.bookmarkButton)
    self.bookmarkButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.left.equalTo(self.titleLabel.snp.right)
    }

    let searchTitle = NSAttributedString(
      string: Localization.search,
      attributes: Constants.Header.Search.attributes
    )
    self.searchButton.setAttributedTitle(searchTitle, for: .normal)
    self.searchButton.contentEdgeInsets = Constants.Header.Search.insets
    self.searchButton.addTarget(self,
                                action: #selector(didPressSearchButton),
                                for: .touchUpInside)

    self.headerView.contentView.addSubview(self.searchButton)
    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    self.headerView.contentView.addSubview(self.lineTypeSelector)
    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.Header.LineType.topOffset)
      make.bottom.equalToSuperview().offset(-Constants.Header.LineType.bottomOffset)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
      make.height.equalTo(LineTypeSegmentedControlConstants.nominalHeight)
    }
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
