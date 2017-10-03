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

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let hasSeenTutorial = Managers.app.hasSeenTutorial
    if !hasSeenTutorial {
      let tutorial = TutorialViewController(mode: .firstUse, delegate: self)
      self.present(tutorial, animated: true, completion: nil)
    }
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
    let tintColor = Managers.theme.colorScheme.tintColor.value

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

extension MainViewController: TutorialViewControllerDelegate {
  func tutorialViewControllerWillClose(_ viewController: TutorialViewController) {
    Managers.app.hasSeenTutorial = true
    Managers.location.requestAuthorization()
  }
}