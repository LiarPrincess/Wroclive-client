//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

private typealias Layout = MainViewControllerConstants.Layout

extension MainViewController {

  func initLayout() {
    self.initMapView()
    self.initToolbarView()
  }

  private func initMapView() {
    self.addChildViewController(self.mapViewController)
    self.view.addSubview(self.mapViewController.view)

    self.mapViewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.mapViewController.didMove(toParentViewController: self)
  }

  private func initToolbarView() {
    self.toolbar.accessibilityIdentifier = "MainViewController.toolbar"

    self.userTrackingButton.mapView = self.mapViewController.mapView

    self.searchButton.image  = StyleKit.drawSearchTemplateImage(size: Layout.toolbarImageSize)
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)
    self.searchButton.accessibilityIdentifier = "MainViewController.search"

    self.bookmarksButton.image  = StyleKit.drawStarTemplateImage(size: Layout.toolbarImageSize)
    self.bookmarksButton.target = self
    self.bookmarksButton.action = #selector(bookmarksButtonPressed)
    self.bookmarksButton.accessibilityIdentifier = "MainViewController.bookmarks"

    self.configurationButton.image  = StyleKit.drawCogwheelTemplateImage(size: Layout.toolbarImageSize)
    self.configurationButton.target = self
    self.configurationButton.action = #selector(configurationButtonPressed)
    self.configurationButton.accessibilityIdentifier = "MainViewController.configuration"

    self.toolbar.setItems(self.layoutToolbarItems(), animated: false)
    self.view.addSubview(self.toolbar)

    self.toolbar.snp.makeConstraints { make in
      make.left.right.equalToSuperview()

      if #available(iOS 11.0, *) {
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
      }
      else { make.bottom.equalToSuperview() }
    }
  }

  private func layoutToolbarItems() -> [UIBarButtonItem] {
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    let result: [UIBarButtonItem] = [
      self.userTrackingButton,  flexible,
      self.searchButton,        flexible,
      self.bookmarksButton,     flexible,
      self.configurationButton
    ]
    return result
  }
}
