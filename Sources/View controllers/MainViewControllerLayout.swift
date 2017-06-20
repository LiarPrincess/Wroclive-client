//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

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

    self.searchButton.image  = #imageLiteral(resourceName: "vecSearch")
    self.searchButton.target = self
    self.searchButton.action = #selector(searchButtonPressed)

    self.bookmarksButton.image  = #imageLiteral(resourceName: "vecFavorites1")
    self.bookmarksButton.target = self
    self.bookmarksButton.action = #selector(bookmarksButtonPressed)

    self.configurationButton.image  = #imageLiteral(resourceName: "vecSettings")
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
      flexible, self.userTrackingButton,  flexible, flexible,
      flexible, self.searchButton,        flexible, flexible,
      flexible, self.bookmarksButton,     flexible, flexible,
      flexible, self.configurationButton, flexible
    ]
  }
}
