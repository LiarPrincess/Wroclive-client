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
    self.addLineSelectionControl(self.busSelectionControl)
    self.addLineSelectionControl(self.tramSelectionControl)
  }

  func positionCollectionViewsBelowHeaderView() {
    let navigationBarHeight = self.headerView.bounds.height

    let topOffset   = navigationBarHeight
    let leftOffset  = CGFloat(Layout.leftOffset)
    let rightOffset = CGFloat(Layout.rightOffset)
    let bottomInset = CGFloat(Layout.bottomOffset)

    let contentInset          = UIEdgeInsets(top: topOffset, left: leftOffset, bottom: bottomInset, right: rightOffset)
    let scrollIndicatorInsets = UIEdgeInsets(top: topOffset, left: 0.0,        bottom: 0.0,         right: 0.0)

    self.tramSelectionControl.contentInset = contentInset
    self.busSelectionControl.contentInset  = contentInset
    self.tramSelectionControl.scrollIndicatorInsets = scrollIndicatorInsets
    self.busSelectionControl.scrollIndicatorInsets  = scrollIndicatorInsets
  }

  //MARK: - Private

  private func initHeader() {
    self.headerView.setStyle(.cardPanelHeader)
    self.view.addSubview(self.headerView)

    self.headerView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
    }

    self.cardTitle.setStyle(.headline)
    self.cardTitle.text          = "Lines"
    self.cardTitle.numberOfLines = 0
    self.cardTitle.lineBreakMode = .byWordWrapping
    self.headerView.addSubview(self.cardTitle)

    self.cardTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.Header.topPadding)
      make.left.equalToSuperview().offset(Layout.leftOffset)
    }

    self.searchButton.setStyle(.link)
    self.searchButton.setTitle("Search", for: .normal)
    self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    self.searchButton.setContentHuggingPriority(251.0, for: .horizontal)
    self.headerView.addSubview(self.searchButton)

    self.searchButton.snp.makeConstraints { make in
      make.firstBaseline.equalTo(self.cardTitle.snp.firstBaseline)
      make.left.equalTo(self.cardTitle.snp.right).inset(Layout.Header.horizontalSpacing)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.lineTypeSelector.setStyle()
    self.lineTypeSelector.insertSegment(withTitle: "Trams", at: LineTypeIndex.tram, animated: false)
    self.lineTypeSelector.insertSegment(withTitle: "Buses", at: LineTypeIndex.bus, animated: false)
    self.lineTypeSelector.addTarget(self, action: #selector(lineTypeChanged), for: .valueChanged)
    self.headerView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.cardTitle.snp.bottom).offset(Layout.Header.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.bottom.equalToSuperview().offset(-Layout.Header.bottomPadding)
    }
  }

  private func addLineSelectionControl(_ control: LineSelectionControl) {
    self.addChildViewController(control)
    self.view.insertSubview(control.view, belowSubview: self.headerView)

    control.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    control.didMove(toParentViewController: self)
  }

}
