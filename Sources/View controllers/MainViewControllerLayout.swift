//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

fileprivate typealias Layout = MainViewControllerConstants.Layout

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
    self.userTrackingButton.mapView = self.mapViewController.mapView

    self.searchButton.image  = StyleKit.drawSearchImage(size: Layout.toolbarImageSize, renderingMode: .alwaysTemplate)
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)

    self.bookmarksButton.image  = StyleKit.drawStarImage(size: Layout.toolbarImageSize, renderingMode: .alwaysTemplate)
    self.bookmarksButton.target = self
    self.bookmarksButton.action = #selector(bookmarksButtonPressed)

    self.configurationButton.image  = StyleKit.drawCogwheelImage(size: Layout.toolbarImageSize, renderingMode: .alwaysTemplate)
    self.configurationButton.style  = .done
    self.configurationButton.target = self
    self.configurationButton.action = #selector(configurationButtonPressed)

    self.toolbar.setStyle()
    self.toolbar.setItems(self.layoutToolbarItems(), animated: false)
    self.view.addSubview(self.toolbar)

    self.toolbar.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }
  }

  private func layoutToolbarItems() -> [UIBarButtonItem] {
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    return [
      self.userTrackingButton,  flexible,
      self.searchButton,        flexible,
      self.bookmarksButton,     flexible,
      self.configurationButton
    ]
  }
}
