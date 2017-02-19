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

class MainViewController: UIViewController {

  //MARK: - Properties

  fileprivate var state = AppState()

  @IBOutlet weak var buttonUserTracking: UIButton!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var buttonFavorites: UIButton!
  @IBOutlet weak var buttonSettings: UIButton!

  lazy var allButtons: [UIButton] = {
    return [self.buttonUserTracking, self.buttonSearch, self.buttonFavorites, self.buttonSettings]
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

  //MARK: - Actions

  @IBAction func userTrackingButtonClick(_ sender: Any) {
    var nextTrackingMode: MKUserTrackingMode = .none

    switch self.state.trackingMode {
    case .none:
      nextTrackingMode = .follow
    case .follow:
      nextTrackingMode = .followWithHeading
    default:
      nextTrackingMode = .none
    }

    store.dispatch(SetUserTrackingMode(nextTrackingMode))
  }
}

//MARK: - StoreSubscriber

extension MainViewController: StoreSubscriber {

  func newState(state: AppState) {
    if self.state.trackingMode != state.trackingMode {
      self.updateTrackingButton(state.trackingMode)
    }

    //finally at the end update remembered state
    self.state = state
  }

  private func updateTrackingButton(_ trackingMode: MKUserTrackingMode) {
    var imageName = ""

    switch trackingMode {
    case .none:
      imageName = UserTrackingButtonImages.none
    case .follow:
      imageName = UserTrackingButtonImages.follow
    case .followWithHeading:
      imageName = UserTrackingButtonImages.followWithHeading
    }

    self.buttonUserTracking.setImage(UIImage(named: imageName), for: .normal)
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
