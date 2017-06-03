//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

fileprivate typealias Constants = MainViewControllerConstants

//MARK: - MainViewController

class MainViewController: UIViewController {

  //MARK: - Properties

  let mapViewController = MapViewController()

  let userTrackingButton  = MKUserTrackingBarButtonItem()
  let lineSelectionButton = UIBarButtonItem()
  let bookmarksButton     = UIBarButtonItem()
  let configurationButton = UIBarButtonItem()

  var lineSelectionTransitionDelegate: UIViewControllerTransitioningDelegate?
  var bookmarksTransitionDelegate:     UIViewControllerTransitioningDelegate?

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  //MARK: - Actions

  @objc func lineSelectionButtonPressed() {
    let relativeHeight = Constants.CardPanel.lineSelectionRelativeHeight
    let controller     = LineSelectionViewController()

    self.lineSelectionTransitionDelegate = CardPanelTransitionDelegate(for: controller, withRelativeHeight: relativeHeight)
    controller.modalPresentationStyle    = .custom
    controller.transitioningDelegate     = self.lineSelectionTransitionDelegate!

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
