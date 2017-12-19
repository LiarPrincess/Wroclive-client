//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

private typealias Constants = MainViewControllerConstants

protocol MainViewControllerDelegate: class {
  func mainViewControllerDidAppear(_ viewController: MainViewController)

  func mainViewControllerDidTapSearchButton(_ viewController: MainViewController)
  func mainViewControllerDidTapBookmarksButton(_ viewController: MainViewController)
  func mainViewControllerDidTapConfigurationButton(_ viewController: MainViewController)
}

class MainViewController: UIViewController {

  // MARK: - Properties

  weak var delegate: MainViewControllerDelegate?

  let mapViewController: MapViewController = MapViewController()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  // MARK: - Init

  convenience init(delegate: MainViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, delegate: MainViewControllerDelegate? = nil) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.delegate = delegate
    self.startObservingColorScheme()
    self.startObservingVehicleLocations()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.stopObservingColorScheme()
    self.stopObservingVehicleLocations()
  }

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.delegate?.mainViewControllerDidAppear(self)
  }

  // MARK: - Actions

  @objc
  func searchButtonPressed() {
    self.delegate?.mainViewControllerDidTapSearchButton(self)
  }

  @objc
  func bookmarksButtonPressed() {
    self.delegate?.mainViewControllerDidTapBookmarksButton(self)
  }

  @objc
  func configurationButtonPressed() {
    self.delegate?.mainViewControllerDidTapConfigurationButton(self)
  }
}

// MARK: - ColorSchemeObserver, VehicleLocationObserver

extension MainViewController: ColorSchemeObserver, VehicleLocationObserver {

  func colorSchemeDidChange() {
    let tintColor = Managers.theme.colors.tint.value

    self.view.tintColor    = tintColor
    self.toolbar.tintColor = tintColor

    // HACK: In iOS 11 UIBarButtonItem are contained in _UIModernBarButton that prevents seting tint color.
    // Previously: button.customView?.tintColor = color
    self.forEachRecurrentSubview(of: self.toolbar) { $0.tintColor = tintColor }
  }

  private func forEachRecurrentSubview(of view: UIView, do block: (UIView) -> ()) {
    for subview in view.subviews {
      block(subview)
      forEachRecurrentSubview(of: subview, do: block)
    }
  }

  func vehicleLocationsDidUpdate() {
    let result = Managers.tracking.result
    switch result {
    case .success(let locations): self.mapViewController.updateVehicleLocations(locations)
    case .error(let error):       self.presentTrackingError(error)
    }
  }

  private func presentTrackingError(_ error: Error) {
    Managers.tracking.pause()

    let retry: () -> () = {
      let delay = Constants.failedLocationRequestDelay
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) { Managers.tracking.resume() }
    }

    switch error {
    case ApiError.noInternet:
      NetworkAlerts.showNoInternetAlert(in: self, retry: retry)
    default:
      NetworkAlerts.showNetworkingErrorAlert(in: self, retry: retry)
    }
  }
}
