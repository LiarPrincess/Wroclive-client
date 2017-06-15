//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

fileprivate typealias Constants = MainViewControllerConstants

class MainViewController: UIViewController {

  //MARK: - Properties

  let mapViewController = MapViewController()

  let toolbar             = UIToolbar()
  
  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let searchButton        = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var searchTransitionDelegate:    UIViewControllerTransitioningDelegate?
  var bookmarksTransitionDelegate: UIViewControllerTransitioningDelegate?

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  //MARK: - Actions

  @objc func searchButtonPressed() {
    let relativeHeight = Constants.CardPanel.searchRelativeHeight
    let controller     = SearchViewController()

    self.searchTransitionDelegate     = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.searchTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc func bookmarksButtonPressed() {
    let relativeHeight = Constants.CardPanel.bookmarksRelativeHeight
    let controller     = BookmarksViewController()

    self.bookmarksTransitionDelegate  = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate  = self.bookmarksTransitionDelegate!

    self.present(controller, animated: true, completion: nil)
  }

  @objc func configurationButtonPressed() {
    logger.info("configurationButtonPressed")
  }

}
