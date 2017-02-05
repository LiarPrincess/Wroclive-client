//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController {

  //MARK: - Properties

  @IBOutlet weak var mapView: MKMapView!

  @IBOutlet weak var buttonCurrentLocation: UIButton!
  @IBOutlet weak var buttonSearch: UIButton!
  @IBOutlet weak var buttonFavorites: UIButton!
  @IBOutlet weak var buttonSettings: UIButton!
  @IBOutlet weak var buttonContainer: UIVisualEffectView!

  lazy var allButtons: [UIButton] = {
    return [self.buttonCurrentLocation, self.buttonSearch, self.buttonFavorites, self.buttonSettings]
  }()

  //MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()
    self.applyVisualStyles()
  }

  override func viewDidAppear(_ animated: Bool) {
    MapKitHelper.requestInUseAuthorizationIfNeeded()
    self.mapView.showsUserLocation = true
  }

  //MARK: - Actions

  @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
    if !MapKitHelper.authorizationStatus.allowsLocalization {
      MapKitHelper.presentAlertToChangeAuthorization(parent: self)
    }

    if MapKitHelper.authorizationStatus.allowsLocalization {
      //do something
    }
  }

  //MARK: - Methods

}

//MARK: - User interface

extension MainController {

  func applyVisualStyles() {

    //[buttonContainer] top border
    self.buttonContainer.addBorder(edges: .top, color: UIColor(white: 0.80, alpha: 0.65), thickness: 0.75)

    //[buttons] center and scale image
    for button in self.allButtons {
      button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
      button.imageView?.contentMode = .scaleAspectFit
    }
  }

}
