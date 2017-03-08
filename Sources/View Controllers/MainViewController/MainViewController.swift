//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit
import ReSwift

struct MainViewControllerConstants {

  static let StoryboardName = "Main"

  struct Segues {
    static let showLineSelectionViewController = "ShowSearchViewController"
    static let showBookmarksViewController = "ShowBookmarksViewController"
  }

  struct UserTrackingImages {
    static let none              = "vecUserTracking_None"
    static let follow            = "vecUserTracking_Follow"
    static let followWithHeading = "vecUserTracking_Follow"
  }

  struct Modal {
    static let lineSelectionRelativeHeight: CGFloat = 0.90
    static let bookmarksRelativeHeight: CGFloat = 0.75
  }
}

class MainViewController: UIViewController {

  //MARK: - Properties

  fileprivate var lineSelectionTransitionDelegate:CardPanelTransitionDelegate?
  fileprivate var bookmarksTransitionDelegate: CardPanelTransitionDelegate?

  @IBOutlet weak var buttonUserTracking: UIButton!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var buttonBookmarks: UIButton!
  @IBOutlet weak var buttonSettings: UIButton!
  @IBOutlet weak var buttonContainerView: UIVisualEffectView!

  lazy var allButtons: [UIButton] = {
    return [self.buttonUserTracking, self.buttonSearch, self.buttonBookmarks, self.buttonSettings]
  }()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.customizeAppearance()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    store.subscribe(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    store.unsubscribe(self)
  }

  //MARK: - Navigation

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    //we will manage those transitions with state changes
    let lineSelectionSegueIdentifier = MainViewControllerConstants.Segues.showLineSelectionViewController
    let bookmarkSegueIdentifier = MainViewControllerConstants.Segues.showBookmarksViewController

    if identifier == lineSelectionSegueIdentifier || identifier == bookmarkSegueIdentifier {
      return false
    }

    return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
  }

  //MARK: - Actions

  @IBAction func userTrackingButtonPressed(_ sender: Any) {
    store.dispatch(ToggleUserTrackingMode())
  }

  @IBAction func searchButtonPressed(_ sender: Any) {
    store.dispatch(SetLineSelectionVisibility(true))
  }

  @IBAction func bookmarksButtonPressed(_ sender: Any) {
    store.dispatch(SetBookmarksVisibility(true))
  }

  //MARK: - Methods

  fileprivate func customizeAppearance() {
    //[buttons] center images
    for button in self.allButtons {
      let verticalInset = button.bounds.height / 4.0
      button.imageEdgeInsets = UIEdgeInsets(top: verticalInset, left: 0.0, bottom: verticalInset, right: 0.0)
      button.imageView?.contentMode = .scaleAspectFit
    }
  }

}

//MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

  func newState(state: AppState) {
    let userTrackingImage = self.getUserTrackingImage(for: state.trackingMode)
    self.buttonUserTracking.setImage(UIImage(named: userTrackingImage), for: .normal)

    if state.lineSelectionState.visible {
      self.showLineSelectionPanel()
    }

    if state.bookmarksState.visible {
      self.showBookmarksPanel()
    }
  }

  private func getUserTrackingImage(for trackingMode: MKUserTrackingMode) -> String {
    switch trackingMode {
    case .none:
      return MainViewControllerConstants.UserTrackingImages.none
    case .follow:
      return MainViewControllerConstants.UserTrackingImages.follow
    case .followWithHeading:
      return MainViewControllerConstants.UserTrackingImages.followWithHeading
    }
  }

  private func showLineSelectionPanel() {
    let relativeHeight = MainViewControllerConstants.Modal.lineSelectionRelativeHeight
    let identifier = LineSelectionViewController.identifier

    let storyboard = UIStoryboard(name: MainViewControllerConstants.StoryboardName, bundle: nil)
    let modalViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! LineSelectionViewController

    self.lineSelectionTransitionDelegate = CardPanelTransitionDelegate(for: modalViewController, withRelativeHeight: relativeHeight)
    modalViewController.modalPresentationStyle = .custom
    modalViewController.transitioningDelegate = self.lineSelectionTransitionDelegate!

    self.present(modalViewController, animated: true, completion: nil)
  }

  private func showBookmarksPanel() {
    let relativeHeight = MainViewControllerConstants.Modal.bookmarksRelativeHeight
    let identifier = BookmarksViewController.identifier

    let storyboard = UIStoryboard(name: MainViewControllerConstants.StoryboardName, bundle: nil)
    let modalViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! BookmarksViewController

    self.bookmarksTransitionDelegate = CardPanelTransitionDelegate(for: modalViewController, withRelativeHeight: relativeHeight)
    modalViewController.modalPresentationStyle = .custom
    modalViewController.transitioningDelegate = self.bookmarksTransitionDelegate!

    self.present(modalViewController, animated: true, completion: nil)
  }

}
