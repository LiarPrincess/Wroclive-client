//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

//MARK: - UI Init

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

    self.lineSelectionButton.image  = #imageLiteral(resourceName: "vecSearch")
    self.lineSelectionButton.target = self
    self.lineSelectionButton.action = #selector(lineSelectionButtonPressed)

    self.bookmarksButton.image  = #imageLiteral(resourceName: "vecFavorites1")
    self.bookmarksButton.target = self
    self.bookmarksButton.action = #selector(bookmarksButtonPressed)

    self.configurationButton.image  = #imageLiteral(resourceName: "vecSettings")
    self.configurationButton.style = .done
    self.configurationButton.target = self
    self.configurationButton.action = #selector(configurationButtonPressed)

    let toolbar = UIToolbar()
    toolbar.setItems(self.spaceToolbarItems(), animated: false)
    self.view.addSubview(toolbar)

    toolbar.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }
  }

  private func spaceToolbarItems() -> [UIBarButtonItem] {
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    var toolbarItems: [UIBarButtonItem] = []
    toolbarItems += [flexible, self.userTrackingButton,  flexible, flexible]
    toolbarItems += [flexible, self.lineSelectionButton, flexible, flexible]
    toolbarItems += [flexible, self.bookmarksButton,     flexible, flexible]
    toolbarItems += [flexible, self.configurationButton, flexible]
    return toolbarItems
  }
}
