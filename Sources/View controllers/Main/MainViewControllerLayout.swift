// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

private typealias Layout = MainViewControllerConstants.Layout

extension MainViewController {

  func initLayout() {
    self.initMapView()
    self.initToolbarView()
  }

  private func initMapView() {
    self.addChildViewController(self.mapViewController)

    let mapView = self.mapViewController.view!
    self.view.addSubview(mapView, constraints: [
      mapView.topAnchor.constraint(equalTo: self.view.topAnchor), // so we are under status bar and toolbar
      mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      mapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      mapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
    ])

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

    self.view.addSubview(self.toolbar, constraints: [
      self.toolbar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
      self.toolbar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
      self.toolbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  private func layoutToolbarItems() -> [UIBarButtonItem] {
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    let result: [UIBarButtonItem] = [
      self.userTrackingButton,  space,
      self.searchButton,        space,
      self.bookmarksButton,     space,
      self.configurationButton
    ]
    return result
  }
}
