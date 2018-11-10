// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout       = SearchCardConstants.Layout
private typealias TextStyles   = SearchCardConstants.TextStyles
private typealias Localization = Localizable.Search

extension SearchCard {

  func initLayout() {
    self.view.backgroundColor = Theme.colors.background

    self.initHeader()
    self.initLinesSelector()
    self.initPlaceholder()

    self.view.bringSubview(toFront: self.headerView)
    self.view.sendSubview(toBack: self.placeholderView)
  }

  // MARK: - Private

  // swiftlint:disable:next function_body_length
  private func initHeader() {
    self.headerView.contentView.addBorder(at: .bottom)
    self.headerView.setContentHuggingPriority(UILayoutPriority(rawValue: 900), for: .vertical)

    self.view.addSubview(self.headerView, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.titleLabel.attributedText = NSAttributedString(string: Localization.title, attributes: TextStyles.cardTitle)
    self.titleLabel.numberOfLines  = 0
    self.titleLabel.lineBreakMode  = .byWordWrapping

    self.headerView.contentView.addSubview(self.titleLabel, constraints: [
      make(\UIView.topAnchor, equalTo: self.chevronView.bottomAnchor, constant: Layout.Header.Title.topOffset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset)
    ])

    let bookmarkImage = StyleKit.drawStarTemplateImage(size: Layout.Header.Bookmark.size)
    self.bookmarkButton.setImage(bookmarkImage, for: .normal)

    self.bookmarkButton.tintColor         = Theme.colors.tint
    self.bookmarkButton.contentEdgeInsets = Layout.Header.Bookmark.insets

    self.headerView.contentView.addSubview(self.bookmarkButton, constraints: [
      make(\UIView.lastBaselineAnchor, equalTo: self.titleLabel.lastBaselineAnchor),
      make(\UIView.leftAnchor, equalTo: self.titleLabel.rightAnchor)
    ])

    let searchTitle = NSAttributedString(string: Localization.search, attributes: TextStyles.search)
    self.searchButton.setAttributedTitle(searchTitle, for: .normal)
    self.searchButton.contentEdgeInsets = Layout.Header.Search.insets

    self.headerView.contentView.addSubview(self.searchButton, constraints: [
      make(\UIView.lastBaselineAnchor, equalTo: self.titleLabel.lastBaselineAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    self.headerView.contentView.addSubview(self.lineTypeSelector, constraints: [
      make(\UIView.topAnchor, equalTo: self.titleLabel.bottomAnchor, constant: Layout.Header.LineType.topOffset),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor, constant: -Layout.Header.LineType.bottomOffset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.rightInset),
      make(\UIView.heightAnchor, equalToConstant: LineTypeSelectorConstants.Layout.nominalHeight)
    ])

    self.view.bringSubview(toFront: self.chevronViewContainer)
  }

  private func initLinesSelector() {
    self.addChildViewController(self.lineSelector)
    self.view.addSubview(self.lineSelector.view, constraints: makeEdgesEqualToSuperview())
    self.lineSelector.didMove(toParentViewController: self)
  }

  private func initPlaceholder() {
    let container = UIView()

    self.view.addSubview(container, constraints: [
      make(\UIView.topAnchor, equalTo: self.headerView.contentView.bottomAnchor),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])

    container.addSubview(self.placeholderView, constraints: [
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.centerYAnchor),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.Placeholder.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.Placeholder.rightInset)
    ])
  }
}
