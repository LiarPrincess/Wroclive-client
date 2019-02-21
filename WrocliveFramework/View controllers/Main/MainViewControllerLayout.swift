// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import MapKit

private typealias Layout = MainViewControllerConstants.Layout

public extension MainViewController {

  public func initLayout() {
    self.initMapView()
    self.initToolbarView()
  }

  private func initMapView() {
    self.addChild(self.mapViewController)

    let mapView = self.mapViewController.view!
    self.view.addSubview(mapView, constraints: [
      // ignore safeAreaLayoutGuide, so we are under status bar and toolbar
      make(\UIView.topAnchor,    equalToSuperview: \UIView.topAnchor),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor)
    ])

    self.mapViewController.didMove(toParent: self)
  }

  private func initToolbarView() {
    self.userTrackingButton.mapView = self.mapViewController.mapView
    self.addButtonSizeConstraints(self.userTrackingButton.customView!)

    self.customizeButton(self.searchButton, image: Assets.vecMagnifier)
    self.searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)

    self.customizeButton(self.bookmarksButton, image: Assets.vecHeart)
    self.bookmarksButton.addTarget(self, action: #selector(bookmarksButtonPressed), for: .touchUpInside)

    self.customizeButton(self.configurationButton, image: Assets.vecCog)
    self.configurationButton.addTarget(self, action: #selector(configurationButtonPressed), for: .touchUpInside)

    self.toolbar.contentView.addTopBorder()
    self.view.addSubview(self.toolbar, constraints: [
      make(\UIView.bottomAnchor, equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor)
    ])

    let stackView = self.createToolbarStackView()
    toolbar.contentView.addSubview(stackView, constraints: [
      make(\UIView.topAnchor,    equalToSuperview: \UIView.topAnchor),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor,  constant:  8.0),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor, constant: -8.0)
    ])
  }

  private func customizeButton(_ button: UIButton, image asset: ImageAsset) {
    let inset = CGFloat(10.0)
    button.setImage(asset.image, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
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

  private func createToolbarStackView() -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: [
      self.userTrackingButton.customView!,
      self.searchButton,
      self.bookmarksButton,
      self.configurationButton
    ])
    stackView.axis = .horizontal
    stackView.distribution = .equalCentering

    return stackView
  }
}
