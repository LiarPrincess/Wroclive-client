//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias NoInternet      = Localizable.Alert.Network.NoInternet
private typealias ConnectionError = Localizable.Alert.Network.ConnectionError

class NetworkAlerts {

  // MARK: - NoInternet

  /// Prompt: check network settings. try again
  static func showNoInternetAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = NoInternet.title
    let message = NoInternet.content
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let againAction = UIAlertAction(title: NoInternet.tryAgain, style: .cancel)  { _ in retry() }
    alert.addAction(againAction)
    
    parent.present(alert, animated: true, completion: nil)
  }

  // MARK: - ConnectionError
  
  /// Prompt: connection error alert. try again
  static func showNetworkingErrorAlert(in parent: UIViewController, retry: @escaping () -> ()) {
    let title   = ConnectionError.title
    let message = ConnectionError.content
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let againAction = UIAlertAction(title: ConnectionError.tryAgain, style: .cancel) { _ in retry() }
    alert.addAction(againAction)
    
    parent.present(alert, animated: true, completion: nil)
  }
}
