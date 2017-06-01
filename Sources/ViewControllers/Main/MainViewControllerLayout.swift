//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

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
    self.userTrackingButton.image  = #imageLiteral(resourceName: "vecUserTracking_None")
    self.userTrackingButton.target = self
    self.userTrackingButton.action = #selector(userTrackingButtonPressed)

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

    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolbarItems = [self.userTrackingButton, flexible, self.lineSelectionButton, flexible, self.bookmarksButton, flexible, self.configurationButton]

    let toolbar = UIToolbar()
    toolbar.setItems(toolbarItems, animated: false)
    self.view.addSubview(toolbar)

    toolbar.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }
  }
}
