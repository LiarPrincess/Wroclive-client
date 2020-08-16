// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit
import SnapKit

// swiftlint:disable force_unwrapping
// ^^^ We have a lot of view thingies to unwrap

extension MainViewController {

  internal func initLayout() {
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

  // swiftlint:disable:next function_body_length
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

    // 'stackView' is responsible for an actual frame on iPhone X+
    // (it has constraint to safe area).
    self.view.addSubview(self.toolbar)
    self.toolbar.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }

    self.toolbarStackView.addArrangedSubview(self.userTrackingButton.customView!)
    self.toolbarStackView.addArrangedSubview(self.searchButton)
    self.toolbarStackView.addArrangedSubview(self.bookmarksButton)
    self.toolbarStackView.addArrangedSubview(self.configurationButton)
    self.toolbarStackView.axis = .horizontal
    self.toolbarStackView.distribution = .equalCentering

    self.toolbar.contentView.addSubview(self.toolbarStackView)
    self.toolbarStackView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
    button.contentVerticalAlignment = .fill
    button.contentHorizontalAlignment = .fill

    self.addButtonSizeConstraints(button)
  }

  private func addButtonSizeConstraints(_ view: UIView) {
    NSLayoutConstraint.activate([
      view.widthAnchor.constraint(equalToConstant: 44.0),
      view.heightAnchor.constraint(equalToConstant: 44.0)
    ])
  }
}
