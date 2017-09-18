//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

private typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController = MapViewController()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  // MARK: - Init

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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

  // MARK: - Actions

  @objc func searchButtonPressed() {
    let controller      = SearchViewController()
    controller.delegate = self
    self.presentCardPanel(controller)
  }

  @objc func bookmarksButtonPressed() {
    let controller      = BookmarksViewController()
    controller.delegate = self
    self.presentCardPanel(controller)
  }

  @objc func configurationButtonPressed() {
    let controller = ConfigurationViewController()
    self.presentCardPanel(controller)
  }

  private func presentCardPanel<TCardPanel>(_ controller: TCardPanel)
    where TCardPanel: UIViewController, TCardPanel: CardPanelPresentable
  {
    self.cardPanelTransitionDelegate  = CardPanelTransitionDelegate(for: controller)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.cardPanelTransitionDelegate!
    self.present(controller, animated: true, completion: nil)
  }
}

// MARK: - ColorSchemeObserver, VehicleLocationObserver

extension MainViewController: ColorSchemeObserver, VehicleLocationObserver {
  func colorSchemeDidChange() {
    let colorScheme = Managers.theme.colorScheme
    self.view.tintColor    = colorScheme.tintColor.value
    self.toolbar.tintColor = colorScheme.tintColor.value

    self.userTrackingButton.tintColor             = colorScheme.tintColor.value
    self.userTrackingButton.customView?.tintColor = colorScheme.tintColor.value
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
    case NetworkError.noInternet:
      Managers.alert.showNoInternetAlert(in: self, retry: retry)
    default:
      Managers.alert.showNetworkingErrorAlert(in: self, retry: retry)
    }
  }
}

// MARK: - SearchViewControllerDelegate

extension MainViewController: SearchViewControllerDelegate {
  func searchViewController(_ controller: SearchViewController, didSelect lines: [Line]) {
    Managers.tracking.start(lines)
  }
}

// MARK: - BookmarksViewControllerDelegate

extension MainViewController: BookmarksViewControllerDelegate {
  func bookmarksViewController(_ controller: BookmarksViewController, didSelect bookmark: Bookmark) {
    Managers.tracking.start(bookmark.lines)
  }
}
