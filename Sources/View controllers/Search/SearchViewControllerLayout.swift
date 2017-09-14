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
    Managers.theme.applyCardPanelStyle(self.view)

    self.initHeader()
    self.initLinesSelector()
    self.initLinesSelectorPlaceholder()
  }

  // MARK: - Private

  private func initHeader() {
    Managers.theme.applyCardPanelHeaderStyle(self.headerView)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state = .down
    self.chevronView.color = Managers.theme.colorScheme.backgroundAccent
    self.chevronView.animationDuration = Constants.CardPanel.chevronDismissRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronY)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    let titleAttributes = Managers.theme.textAttributes(for: .headline)
    self.cardTitle.attributedText = NSAttributedString(string: Localization.cardTitle, attributes: titleAttributes)
    self.cardTitle.numberOfLines  = 0
    self.cardTitle.lineBreakMode  = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    let bookmarkImage = StyleKit.drawStarTemplateImage(size: Layout.Header.bookmarkButtonSize)

    self.bookmarkButton.tintColor = Managers.theme.colorScheme.tintColor.value
    self.bookmarkButton.setImage(bookmarkImage, for: .normal)
    self.bookmarkButton.contentEdgeInsets = Layout.Header.bookmarkButtonInsets
    self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.bookmarkButton)

    self.bookmarkButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.left.equalTo(self.cardTitle.snp.right)
    }

    let searchAttributes = Managers.theme.textAttributes(for: .body, color: .tint)
    let searchTitle      = NSAttributedString(string: Localization.search, attributes: searchAttributes)
    self.searchButton.setAttributedTitle(searchTitle, for: .normal)
    self.searchButton.contentEdgeInsets = Layout.Header.searchButtonInsets
    self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.searchButton)

    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    self.lineTypeSelector.delegate = self
    self.headerView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.cardTitle.snp.bottom).offset(Layout.Header.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
      make.height.equalTo(LineTypeSelectionControl.nominalHeight)
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

  private func initLinesSelectorPlaceholder() {
    self.view.insertSubview(self.placeholderView, belowSubview: self.linesSelector.view)

    self.placeholderView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.snp.bottom)
      make.left.equalToSuperview().offset(Layout.Placeholder.leftInset)
      make.right.equalToSuperview().offset(-Layout.Placeholder.rightInset)
      make.bottom.equalToSuperview()
    }

    self.placeholderView.addSubview(self.placeholderSpinner)

    self.placeholderSpinner.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
    }

    let textAttributes = Managers.theme.textAttributes(for: .body, alignment: .center)
    self.placeholderLabel.attributedText = NSAttributedString(string: Localization.loading, attributes: textAttributes)
    self.placeholderLabel.numberOfLines  = 0
    self.placeholderLabel.lineBreakMode  = .byWordWrapping
    self.placeholderView.addSubview(self.placeholderLabel)

    self.placeholderLabel.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderSpinner.snp.bottom).offset(Layout.Placeholder.verticalSpacing)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.placeholderView.snp.centerY)
    }
  }
}
