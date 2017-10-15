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

  typealias Dependencies = HasThemeManager
                         & HasLocationManager
                         & HasTrackingManager
                         & HasAlertManager
                         & HasNotificationManager

  // MARK: - Properties

  let managers:      Dependencies
  weak var delegate: MainViewControllerDelegate?

  lazy var mapViewController: MapViewController = {
    return MapViewController(managers: self.managers)
  }()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  // MARK: - Init

  convenience init(managers: Dependencies, delegate: MainViewControllerDelegate? = nil) {
    self.init(nibName: nil, bundle: nil, managers: managers, delegate: delegate)
  }

  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, managers: Dependencies, delegate: MainViewControllerDelegate? = nil) {
    self.managers = managers
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

  @objc func searchButtonPressed() {
    self.delegate?.mainViewControllerDidTapSearchButton(self)
  }

  @objc func bookmarksButtonPressed() {
    self.delegate?.mainViewControllerDidTapBookmarksButton(self)
  }

  @objc func configurationButtonPressed() {
    self.delegate?.mainViewControllerDidTapConfigurationButton(self)
  }
}

// MARK: - ColorSchemeObserver, VehicleLocationObserver

extension MainViewController: ColorSchemeObserver, VehicleLocationObserver, HasNotificationManager {

  var notification: NotificationManager { return self.managers.notification }

  func colorSchemeDidChange() {
    let tintColor = self.managers.theme.colorScheme.tintColor.value

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
    let result = self.managers.tracking.result
    switch result {
    case .success(let locations): self.mapViewController.updateVehicleLocations(locations)
    case .error(let error):       self.presentTrackingError(error)
    }
  }

  private func presentTrackingError(_ error: Error) {
    self.managers.tracking.pause()

    let retry: () -> () = {
      let delay = Constants.failedLocationRequestDelay
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) { self.managers.tracking.resume() }
    }

    switch error {
    case NetworkError.noInternet:
      self.managers.alert.showNoInternetAlert(in: self, retry: retry)
    default:
      self.managers.alert.showNetworkingErrorAlert(in: self, retry: retry)
    }
  }
}
