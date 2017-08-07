//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = SearchViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

extension SearchViewController {

  func initLayout() {
    self.view.setStyle(.cardPanel)

    self.initHeader()
    self.initLinesSelector()
    self.initLinesSelectorPlaceholder()
  }

  // MARK: - Private

  private func initHeader() {
    self.headerView.setStyle(.cardPanelHeader)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.chevronView.state = .down
    self.chevronView.color = Theme.current.colorScheme.backgroundContrast
    self.chevronView.animationDuration = Constants.Animations.chevronDismissRelativeDuration
    self.view.addSubview(chevronView)

    self.chevronView.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(Layout.Header.chevronY)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }

    self.cardTitle.setStyle(.headline)
    self.cardTitle.text          = "Lines"
    self.cardTitle.numberOfLines = 0
    self.cardTitle.lineBreakMode = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
    }

    self.bookmarkButton.setStyle(.templateImage)
    self.bookmarkButton.setImage(#imageLiteral(resourceName: "vecFavorites1"), for: .normal)
    self.bookmarkButton.contentEdgeInsets = Layout.Header.bookmarkButtonInsets
    self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.bookmarkButton)

    self.bookmarkButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.left.equalTo(self.cardTitle.snp.right)
    }

    self.searchButton.setStyle(.link)
    self.searchButton.setTitle("Search", for: .normal)
    self.searchButton.contentEdgeInsets = Layout.Header.searchButtonInsets
    self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    self.headerView.addSubview(self.searchButton)

    self.searchButton.snp.makeConstraints { make in
      make.lastBaseline.equalTo(self.cardTitle.snp.lastBaseline)
      make.right.equalToSuperview()
    }

    self.lineTypeSelector.setStyle()
    self.lineTypeSelector.delegate = self
    self.headerView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.cardTitle.snp.bottom).offset(Layout.Header.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomInset)
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

    self.placeholderLabel.setStyle(.body)
    self.placeholderLabel.numberOfLines = 0
    self.placeholderLabel.textAlignment = .center
    self.placeholderLabel.lineBreakMode = .byWordWrapping
    self.placeholderLabel.text          = "Loading…"
    self.placeholderView.addSubview(self.placeholderLabel)

    self.placeholderLabel.snp.makeConstraints { make in
      make.top.equalTo(self.placeholderSpinner.snp.bottom).offset(Layout.Placeholder.verticalSpacing)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.placeholderView.snp.centerY)
    }
  }
}
