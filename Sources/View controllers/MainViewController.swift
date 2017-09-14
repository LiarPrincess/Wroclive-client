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

  var trackedLines:  [Line] = []
  var trackingTimer: Timer?

  // MARK: - Init

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.startObservingColorScheme()
    self.startObservingAppStateToManageTimer()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func startObservingColorScheme() {
    let notification = Notification.Name.colorSchemeDidChange
    NotificationCenter.default.addObserver(self, selector: #selector(colorSchemeDidChanged), name: notification, object: nil)
  }

  func colorSchemeDidChanged() {
    let colorScheme = Managers.theme.colorScheme
    self.view.tintColor               = colorScheme.tintColor.value
    self.toolbar.tintColor            = colorScheme.tintColor.value

    self.userTrackingButton.tintColor             = colorScheme.tintColor.value
    self.userTrackingButton.customView?.tintColor = colorScheme.tintColor.value
  }

  private func startObservingAppStateToManageTimer() {
    let didBecomeActive = NSNotification.Name.UIApplicationDidBecomeActive
    NotificationCenter.default.addObserver(self, selector: #selector(startUpdateTimerWhenApplicationDidBecomeActive),  name: didBecomeActive,  object: nil)

    let willResignActive = NSNotification.Name.UIApplicationWillResignActive
    NotificationCenter.default.addObserver(self, selector: #selector(stopUpdateTimerWhenApplicationWillResignActive), name: willResignActive, object: nil)
  }

  func startUpdateTimerWhenApplicationDidBecomeActive(withNotification notification : NSNotification) {
    self.startLocationUpdateTimer()
  }

  func stopUpdateTimerWhenApplicationWillResignActive(withNotification notification : NSNotification) {
    self.stopLocationUpdateTimer()
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

  // MARK: - Private - Tracking

  fileprivate func startTracking(_ lines: [Line]) {
    self.trackedLines = lines
    self.startLocationUpdateTimer()
  }

  // MARK: - Private - Timers

  private func startLocationUpdateTimer() {
    self.stopLocationUpdateTimer()

    guard self.trackedLines.count > 0 else {
      self.mapViewController.removeAllAnnotations()
      return
    }

    let interval = Constants.locationUpdateInterval
    self.trackingTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(trackingTimerFired), userInfo: nil, repeats: true)
    self.trackingTimer?.tolerance = interval * 0.1

    // manually perform first update
    self.trackingTimer?.fire()
  }

  func trackingTimerFired(timer: Timer) {
    guard timer.isValid else { return }

    firstly { return Managers.network.getVehicleLocations(for: self.trackedLines) }
    .then  { self.mapViewController.updateVehicleLocations($0) }
    .catch { error in
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
