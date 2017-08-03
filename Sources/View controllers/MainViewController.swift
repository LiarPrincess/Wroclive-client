//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import PromiseKit

fileprivate typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController = MapViewController()

  let toolbar = UIToolbar()
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var searchTransitionDelegate:    UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
  var bookmarksTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  var trackedLines:  [Line] = []
  var trackingTimer: Timer?

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  // MARK: - Actions

  @objc func searchButtonPressed() {
    let relativeHeight  = Constants.CardPanel.searchRelativeHeight
    let controller      = SearchViewController()
    controller.delegate = self

    self.searchTransitionDelegate     = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.searchTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc func bookmarksButtonPressed() {
    let relativeHeight  = Constants.CardPanel.bookmarksRelativeHeight
    let controller      = BookmarksViewController()
    controller.delegate = self

    self.bookmarksTransitionDelegate  = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.bookmarksTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc func configurationButtonPressed() {
    Swift.print("configurationButtonPressed")
  }

  // MARK: - Private - Tracking

  fileprivate func startTracking(_ lines: [Line]) {
    self.trackedLines = lines
    self.startLocationUpdateTimer()
  }

  // MARK: - Private - Timers

  private func startLocationUpdateTimer() {
    self.stopLocationUpdateTimer()

    let interval = Constants.locationUpdateInterval
    self.trackingTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(trackingTimerFired), userInfo: nil, repeats: true)
    self.trackingTimer?.tolerance = interval * 0.1

    // manually perform first update
    self.trackingTimer?.fire()
  }

  func trackingTimerFired(timer: Timer) {
    guard timer.isValid else { return }

    firstly   { return Managers.network.getVehicleLocations(for: self.trackedLines) }
      .then   { self.mapViewController.updateVehicleLocations($0) }
      .catch  { error in
        self.stopLocationUpdateTimer()

        let retry = { [weak self] in
          let delay = Constants.failedRequestDelay
          DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.startLocationUpdateTimer()
          }
        }

        switch error {
        case NetworkError.noInternet:
          Managers.alert.showNoInternetAlert(in: self, retry: retry)
        default:
          Managers.alert.showNetworkingErrorAlert(in: self, retry: retry)
        }
    }
  }

  private func stopLocationUpdateTimer() {
    self.trackingTimer?.invalidate()
  }

}

// MARK: - SearchViewControllerDelegate

extension MainViewController: SearchViewControllerDelegate {

  func searchViewController(_ controller: SearchViewController, didSelect lines: [Line]) {
    self.startTracking(lines)
  }

}

// MARK: - BookmarksViewControllerDelegate

extension MainViewController: BookmarksViewControllerDelegate {

  func bookmarksViewController(_ controller: BookmarksViewController, didSelect bookmark: Bookmark) {
    self.startTracking(bookmark.lines)
  }

}
