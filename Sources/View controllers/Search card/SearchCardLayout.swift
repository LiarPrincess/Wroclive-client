//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout       = SearchCardConstants.Layout
private typealias TextStyles   = SearchCardConstants.TextStyles
private typealias Localization = Localizable.Search

extension SearchCard {

  func initLayout() {
    self.view.backgroundColor = Managers.theme.colors.background
    self.initHeader()
    self.initLinesSelector()
    self.initPlaceholder()
  }

  // MARK: - Private

  // swiftlint:disable:next function_body_length
  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.insertSubview(self.headerView, belowSubview: self.chevronViewContainer)
    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.chevronView.snp.bottom).offset(Layout.Header.Title.topOffset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    let bookmarkImage = StyleKit.drawStarTemplateImage(size: Layout.Header.Bookmark.size)
    self.bookmarkButton.setImage(bookmarkImage, for: .normal)

    self.bookmarkButton.tintColor         = Managers.theme.colors.tint
    self.bookmarkButton.contentEdgeInsets = Layout.Header.Bookmark.insets

    self.headerView.contentView.addSubview(self.bookmarkButton)
    self.bookmarkButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.left.equalTo(self.titleLabel.snp.right)
    }

    let searchTitle = NSAttributedString(string: Localization.search, attributes: TextStyles.search)
    self.searchButton.setAttributedTitle(searchTitle, for: .normal)
    self.searchButton.contentEdgeInsets = Layout.Header.Search.insets

    self.headerView.contentView.addSubview(self.searchButton)
    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.titleLabel.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    self.headerView.contentView.addSubview(self.lineTypeSelector)
    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(Layout.Header.LineType.topOffset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.LineType.bottomOffset)
      make.height.equalTo(LineTypeSelectorConstants.Layout.nominalHeight)
    }
  }

  private func initLinesSelector() {
    self.addChildViewController(self.lineSelector)

    self.view.insertSubview(self.lineSelector.view, belowSubview: self.headerView)
    self.lineSelector.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.lineSelector.didMove(toParentViewController: self)
  }

  private func initPlaceholder() {
    let container = UIView()

    self.view.insertSubview(container, belowSubview: self.lineSelector.view)
    container.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.contentView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }

    container.addSubview(self.placeholderView)
    self.placeholderView.snp.makeConstraints { make in
      make.bottom.equalTo(container.snp.centerY)
      make.left.equalToSuperview().offset(Layout.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightInset)
    }
  }
}
