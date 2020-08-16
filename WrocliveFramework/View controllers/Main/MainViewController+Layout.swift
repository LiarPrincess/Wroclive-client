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
    self.initToolbarButtons()
  }

  // MARK: - Map

  private func initMapView() {
    self.addChild(self.mapViewController)

    let mapView = self.mapViewController.view!

    // Ignore safeAreaLayoutGuide, so we are under status bar and toolbar
    self.view.addSubview(mapView)
    mapView.snp.makeConstraints { $0.edges.equalToSuperview() }

    self.mapViewController.didMove(toParent: self)
  }

  // MARK: - Toolbar

  private var buttonSize: CGSize {
    return Constants.toolbarButtonSize
  }

  private var buttonImageSize: CGSize {
    return Constants.toolbarButtonImageSize
  }

  private func initToolbarView() {
    let device = self.environment.device
    self.toolbar.contentView.addTopBorder(device: device)

    // 'stackView' is responsible for an actual frame on iPhone X+
    // (it has constraint to safe area).
    self.view.addSubview(self.toolbar)
    self.toolbar.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
    }
  }

  // MARK: - Toolbar button

  private func initToolbarButtons() {
    self.userTrackingButton.mapView = self.mapViewController.mapView
    self.setSize(view: self.userTrackingButton.customView!, to: self.buttonSize)

    self.customizeButton(self.searchButton,
                         imageName: "tram.empty",
                         action: #selector(searchButtonPressed))

    self.customizeButton(self.bookmarksButton,
                         imageName: "heart",
                         action: #selector(bookmarksButtonPressed))

    self.customizeButton(self.configurationButton,
                         imageName: "gearshape",
                         action: #selector(settingsButtonPressed))

    self.toolbarStackView.addArrangedSubview(self.userTrackingButton.customView!)
    self.toolbarStackView.addArrangedSubview(self.searchButton)
    self.toolbarStackView.addArrangedSubview(self.bookmarksButton)
    self.toolbarStackView.addArrangedSubview(self.configurationButton)
    self.toolbarStackView.axis = .horizontal
    self.toolbarStackView.distribution = .equalCentering

    self.toolbar.contentView.addSubview(self.toolbarStackView)
    self.toolbarStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.toolbarInset)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
      make.left.equalToSuperview().offset(Constants.toolbarInset)
      make.right.equalToSuperview().offset(-Constants.toolbarInset)
    }
  }

  private func customizeButton(_ button: UIButton,
                               imageName: String,
                               action: Selector) {
    let image = self.getImage(name: imageName)
    button.setImage(image, for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)

    guard let imageView = button.imageView else {
      fatalError("Unable to get toolbar button imageView")
    }

    button.contentVerticalAlignment = .center
    button.contentHorizontalAlignment = .center
    self.setSize(view: button, to: self.buttonSize)
    self.setSize(view: imageView, to: self.buttonImageSize)
  }

  private final class BundleToken {}

  private func getImage(name: String) -> UIImage {
    let bundle = Bundle(for: BundleToken.self)

    if #available(iOS 13.0, *) {
      let configuration = UIImage.SymbolConfiguration(weight: .light)
      if let image = UIImage(named: name, in: bundle, with: configuration) {
        return image
      }
    } else {
      if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
        return image
      }
    }

    fatalError("Unable to find image with name: '\(name)'")
  }

  private func setSize(view: UIView, to size: CGSize) {
    view.snp.makeConstraints { make in
      make.width.equalTo(size.width)
      make.height.equalTo(size.height)
    }
  }
}