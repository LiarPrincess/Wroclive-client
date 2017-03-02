//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit
import ReSwift

class MainViewController: UIViewController {

  //MARK: - Properties

  typealias Constants = MainViewControllerConstants

  fileprivate var searchTransitionDelegate = CardPanelTransitionDelegate(withRelativeHeight: Constants.LineSelectionViewController.relativeHeight)
  fileprivate var bookmarkTransitionDelegate = CardPanelTransitionDelegate(withRelativeHeight: Constants.BookmarksViewController.relativeHeight)

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
    self.applyVisualStyles()
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
    let searchSegueIdentifier = Constants.Segues.showSearchViewController
    let bookmarkSegueIdentifier = Constants.Segues.showBookmarksViewController

    if identifier == searchSegueIdentifier || identifier == bookmarkSegueIdentifier {
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

}

//MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

  func newState(state: AppState) {
    let userTrackingImage = self.getUserTrackingImage(for: state.trackingMode)
    self.buttonUserTracking.setImage(UIImage(named: userTrackingImage), for: .normal)

    if state.lineSelectionState.visible {
      self.showSearchPanel()
    }

    if state.bookmarksState.visible {
      self.showBookmarksPanel()
    }
  }

  private func getUserTrackingImage(for trackingMode: MKUserTrackingMode) -> String {
    switch trackingMode {
    case .none:
      return Constants.MainViewController.UserTrackingImages.none
    case .follow:
      return Constants.MainViewController.UserTrackingImages.follow
    case .followWithHeading:
      return Constants.MainViewController.UserTrackingImages.followWithHeading
    }
  }

  private func showSearchPanel() {
    self.showCardPanel(withIdentifier: Constants.LineSelectionViewController.identifier, delegate: self.searchTransitionDelegate)
  }

  private func showBookmarksPanel() {
    self.showCardPanel(withIdentifier: Constants.BookmarksViewController.identifier, delegate: self.bookmarkTransitionDelegate)
  }

  private func showCardPanel(withIdentifier identifier: String, delegate transitioningDelegate: UIViewControllerTransitioningDelegate) {
    let storyboard = UIStoryboard(name: Constants.Storyboards.Main, bundle: nil)

    let modalViewController = storyboard.instantiateViewController(withIdentifier: identifier)
    modalViewController.modalPresentationStyle = .custom
    modalViewController.transitioningDelegate = transitioningDelegate

    self.present(modalViewController, animated: true, completion: nil)
  }

}

//MARK: - User interface

extension MainViewController {

  func applyVisualStyles() {

    //[buttons] center images
    for button in self.allButtons {
      let verticalInset = button.bounds.height / 4.0
      button.imageEdgeInsets = UIEdgeInsets(top: verticalInset, left: 0.0, bottom: verticalInset, right: 0.0)
      button.imageView?.contentMode = .scaleAspectFit
    }
  }
  
}
