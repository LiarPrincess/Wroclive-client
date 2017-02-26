//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit
import ReSwift

fileprivate struct UserTrackingButtonImages {
  static let none              = "vecUserTracking_None"
  static let follow            = "vecUserTracking_Follow"
  static let followWithHeading = "vecUserTracking_Follow"
}

fileprivate struct Segues {
  static let showBookmarksViewController = "ShowBookmarksViewController"
}

class MainViewController: UIViewController {

  //MARK: - Properties

  fileprivate var state: AppState?

  fileprivate var bookmarkTransitionDelegate = SlideUpTransitionDelegate(withRelativeHeight: 0.75)

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
    if identifier == Segues.showBookmarksViewController {
      return false
    }

    return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
  }

  //MARK: - Actions

  @IBAction func userTrackingButtonPressed(_ sender: Any) {
    var nextTrackingMode: MKUserTrackingMode = .none

    switch self.state!.trackingMode {
    case .none:
      nextTrackingMode = .follow
    case .follow:
      nextTrackingMode = .followWithHeading
    default:
      nextTrackingMode = .none
    }

    store.dispatch(SetUserTrackingMode(nextTrackingMode))
  }

  @IBAction func bookmarksButtonPressed(_ sender: Any) {
    store.dispatch(SetBookmarksVisibility(true))
  }

}

//MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

  func newState(state: AppState) {
    updateUserTrackingMode(state)
    updateBookmarksVisibility(state)

    //finally at the end update remembered state
    self.state = state
  }

  private func updateUserTrackingMode(_ state: AppState) {
    guard self.state == nil || self.state!.trackingMode != state.trackingMode else {
      return
    }

    var imageName = ""

    switch state.trackingMode {
    case .none:
      imageName = UserTrackingButtonImages.none
    case .follow:
      imageName = UserTrackingButtonImages.follow
    case .followWithHeading:
      imageName = UserTrackingButtonImages.followWithHeading
    }

    self.buttonUserTracking.setImage(UIImage(named: imageName), for: .normal)
  }

  private func updateBookmarksVisibility(_ state: AppState) {
    guard self.state == nil || self.state!.bookmarksState.visible != state.bookmarksState.visible else {
      return
    }

    if state.bookmarksState.visible {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)

      let bookmarkViewController = storyboard.instantiateViewController(withIdentifier: BookmarksViewController.identifier)
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
