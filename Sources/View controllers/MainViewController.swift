//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

fileprivate typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  // MARK: - Properties

  let mapViewController = MapViewController()

  let toolbar             = UIToolbar()

  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var searchTransitionDelegate:    UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
  var bookmarksTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

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

  // MARK: - Tracking

  fileprivate func startTracking(_ lines: [Line]) {
    _ = Managers.network.getVehicleLocations(for: lines)
    .then { locations in
      self.mapViewController.updateVehicleLocations(locations)
    }
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
