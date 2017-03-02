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

  fileprivate var bookmarkTransitionDelegate = SlideUpTransitionDelegate(withRelativeHeight: Constants.BookmarksViewController.relativeHeight)

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
    if identifier == Constants.Segues.showBookmarksViewController {
      return false
    }

    return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
  }

  //MARK: - Actions

  @IBAction func userTrackingButtonPressed(_ sender: Any) {
    store.dispatch(ToggleUserTrackingMode())
  }

  @IBAction func bookmarksButtonPressed(_ sender: Any) {
    store.dispatch(SetBookmarksVisibility(true))
  }

}

//MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

  func newState(state: AppState) {
    self.updateUserTrackingButton(state)
    self.updateBookmarksVisibility(state)
  }

  private func updateUserTrackingButton(_ state: AppState) {
    var imageName = ""

    switch state.trackingMode {
    case .none:
      imageName = Constants.MainViewController.UserTrackingImages.none
    case .follow:
      imageName = Constants.MainViewController.UserTrackingImages.follow
    case .followWithHeading:
      imageName = Constants.MainViewController.UserTrackingImages.followWithHeading
    }

    self.buttonUserTracking.setImage(UIImage(named: imageName), for: .normal)
  }

  private func updateBookmarksVisibility(_ state: AppState) {
    if state.bookmarksState.visible {
      let storyboard = UIStoryboard(name: Constants.Storyboards.Main, bundle: nil)

      let bookmarkViewController = storyboard.instantiateViewController(withIdentifier: Constants.BookmarksViewController.identifier)
      bookmarkViewController.modalPresentationStyle = .custom
      bookmarkViewController.transitioningDelegate = self.bookmarkTransitionDelegate

      self.present(bookmarkViewController, animated: true, completion: nil)
    }
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
