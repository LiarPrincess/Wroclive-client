//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants    = SearchViewControllerConstants
private typealias Layout       = Constants.Layout
private typealias Localization = Localizable.Search

extension SearchViewController {

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
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    let titleAttributes = Managers.theme.textAttributes(for: .headline)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: titleAttributes)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping
    self.headerView.contentView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    let bookmarkImage = StyleKit.drawStarTemplateImage(size: Layout.Header.bookmarkButtonSize)

    self.bookmarkButton.tintColor = Managers.theme.colors.tint.value
    self.bookmarkButton.setImage(bookmarkImage, for: .normal)
    self.bookmarkButton.contentEdgeInsets = Layout.Header.bookmarkButtonInsets
    self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
    self.headerView.contentView.addSubview(self.bookmarkButton)

    self.bookmarkButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.left.equalTo(self.cardTitle.snp.right)
    }

    let searchAttributes = Managers.theme.textAttributes(for: .body, color: .tint)
    let searchTitle      = NSAttributedString(string: Localization.search, attributes: searchAttributes)
    self.searchButton.setAttributedTitle(searchTitle, for: .normal)
    self.searchButton.contentEdgeInsets = Layout.Header.searchButtonInsets
    self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    self.headerView.contentView.addSubview(self.searchButton)

    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    self.headerView.contentView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.cardTitle.snp.bottom).offset(Layout.Header.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.height.equalTo(LineTypeSelectorConstants.Layout.nominalHeight)
    }
  }

  private func initLinesSelector() {
    self.linesSelector.delegate = self

    self.addChildViewController(self.linesSelector)
    self.view.insertSubview(self.linesSelector.view, belowSubview: self.headerView)

    self.linesSelector.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.linesSelector.didMove(toParentViewController: self)
  }

  private func initPlaceholder() {
    let container = UIView()

    self.view.insertSubview(container, belowSubview: self.linesSelector.view)
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
