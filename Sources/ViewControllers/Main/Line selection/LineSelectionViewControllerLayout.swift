//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

//MARK: - UI Init

extension LineSelectionViewController {

  func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initLinesCollection()
  }

  private func initNavigationBar() {
    self.navigationBarBlurView.addBorder(at: .bottom)
    self.view.addSubview(self.navigationBarBlurView)

    self.navigationBarBlurView.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    // remove background, so that blur view view can be seen
    // see: https://developer.apple.com/library/content/samplecode/NavBar/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007418-Intro-DontLinkElementID_2
    self.initNavigationBarItem()
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBarBlurView.addSubview(self.navigationBar)

    self.navigationBar.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }

    self.initLineTypeSelector()
    self.navigationBarBlurView.addSubview(self.lineTypeSelector)

    self.lineTypeSelector.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBar.snp.bottom).offset(Layout.LineTypeSelector.topOffset)
      make.left.equalToSuperview().offset(Layout.Content.leftOffset)
      make.right.equalToSuperview().offset(-Layout.Content.rightOffset)
      make.bottom.equalTo(self.navigationBarBlurView.snp.bottom).offset(-Layout.LineTypeSelector.bottomOffset)
    }
  }

  private func initNavigationBarItem() {
    self.navigationItem.title = "Select lines"
    self.navigationBar.pushItem(navigationItem, animated: false)

    self.saveButton.style  = .plain
    self.saveButton.title  = "Save"
    self.saveButton.target = self
    self.saveButton.action = #selector(saveButtonPressed)
    self.navigationItem.setLeftBarButton(self.saveButton, animated: false)

    self.searchButton.style  = .plain
    self.searchButton.title  = "Search"
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)
    self.navigationItem.setRightBarButton(self.searchButton, animated: false)
  }

  private func initLineTypeSelector() {
    self.lineTypeSelector.insertSegment(withTitle: "Trams", at: LineTypeIndex.tram, animated: false)
    self.lineTypeSelector.insertSegment(withTitle: "Buses", at: LineTypeIndex.bus, animated: false)
    self.lineTypeSelector.selectedSegmentIndex = LineTypeIndex.tram

    self.lineTypeSelector.addTarget(self, action: #selector(lineTypeChanged), for: .valueChanged)
    self.lineTypeSelector.font = FontManager.instance.lineSelectionLineTypeSelector
  }

  private func initLinesCollection() {
    self.lineCollection.register(LineSelectionCell.self)
    self.lineCollection.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    self.lineCollection.backgroundColor = UIColor.white
    self.lineCollection.allowsSelection = true
    self.lineCollection.allowsMultipleSelection = true
    //self.lineCollection.dataSource will be set later in self.updateLineCollectionDataSource()
    self.lineCollection.delegate = self

    self.view.insertSubview(self.lineCollection, belowSubview: self.navigationBarBlurView)

    self.lineCollection.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBarBlurView.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
}
