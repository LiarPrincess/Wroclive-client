// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import SnapKit

private typealias Layout = MainViewControllerConstants.Layout

internal extension MainViewController {

  func initLayout() {
    self.initMapView()
    self.initToolbarView()
  }

  private func initMapView() {
    self.addChild(self.mapViewController)

    let mapView = self.mapViewController.view!

    // Ignore safeAreaLayoutGuide, so we are under status bar and toolbar
    self.view.addSubview(mapView)
    mapView.snp.makeConstraints { $0.edges.equalToSuperview() }

    self.mapViewController.didMove(toParent: self)
  }

  private func initToolbarView() {
    self.userTrackingButton.mapView = self.mapViewController.mapView
    self.addButtonSizeConstraints(self.userTrackingButton.customView!)

    self.customizeButton(self.searchButton, image: Assets.tabbarSearch)
    self.searchButton.addTarget(self,
                                action: #selector(searchButtonPressed),
                                for: .touchUpInside)

    self.customizeButton(self.bookmarksButton, image: Assets.tabbarBookmarks)
    self.bookmarksButton.addTarget(self,
                                   action: #selector(bookmarksButtonPressed),
                                   for: .touchUpInside)

    self.customizeButton(self.configurationButton, image: Assets.tabbarSettings)
    self.configurationButton.addTarget(self,
                                       action: #selector(settingsButtonPressed),
                                       for: .touchUpInside)

    let device = self.environment.device
    self.toolbar.contentView.addTopBorder(device: device)

    self.view.addSubview(self.toolbar)
    self.toolbar.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }

    let stackView = UIStackView(arrangedSubviews: [
      self.userTrackingButton.customView!,
      self.searchButton,
      self.bookmarksButton,
      self.configurationButton
    ])
    stackView.axis = .horizontal
    stackView.distribution = .equalCentering

    self.toolbar.contentView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.left.equalToSuperview().offset(8.0)
      make.right.equalToSuperview().offset(-8.0)
    }
  }

  // TODO: Move those contants to separate enum
  private func customizeButton(_ button: UIButton, image asset: ImageAsset) {
    let inset = CGFloat(10.0)
    button.setImage(asset.image, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: inset,
                                          left: inset,
                                          bottom: inset,
                                          right: inset)
    button.contentVerticalAlignment   = .fill
    button.contentHorizontalAlignment = .fill

    self.addButtonSizeConstraints(button)
  }

  private func addButtonSizeConstraints(_ view: UIView) {
    NSLayoutConstraint.activate([
      view.widthAnchor .constraint(equalToConstant: 44.0),
      view.heightAnchor.constraint(equalToConstant: 44.0)
    ])
  }
}
