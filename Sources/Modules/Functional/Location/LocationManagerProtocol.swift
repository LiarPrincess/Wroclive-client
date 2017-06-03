//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManagerProtocol {

  //MARK: - Initial region

  func getInitialRegion() -> MKCoordinateRegion

  //MARK: - Authorization

  var authorizationStatus: CLAuthorizationStatus { get }
  
  func requestInUseAuthorization()
  func showAlertForDeniedAuthorization(in parent: UIViewController)
  func showAlertForRestrictedAuthorization(in parent: UIViewController)
}
