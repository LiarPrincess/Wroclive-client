//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants
fileprivate typealias Layout    = Constants.Layout

extension LineSelectionViewController {

  func initLayout() {
    self.view.backgroundColor = UIColor.white
    self.initNavigationBar()
    self.initTramCollection()
    self.initBusCollection()
  }

  //MARK: - Navigation bar

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

  //MARK: - Collections

  private func initTramCollection() {
    self.initCollectionCommon(self.tramCollection)
    self.tramCollection.dataSource = self.tramDataSource
  }

  private func initBusCollection() {
    self.initCollectionCommon(self.busCollection)
    self.busCollection.dataSource = self.busDataSource
  }

  private func initCollectionCommon(_ collection: UICollectionView) {
    collection.register(LineSelectionCell.self)
    collection.registerSupplementary(LineSelectionSectionHeaderView.self, ofKind: UICollectionElementKindSectionHeader)
    collection.backgroundColor         = UIColor.white
    collection.allowsSelection         = true
    collection.allowsMultipleSelection = true
    collection.delegate = self

    self.view.insertSubview(collection, belowSubview: self.navigationBarBlurView)

    collection.snp.makeConstraints { make in
      make.top.equalTo(self.navigationBarBlurView.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

}
