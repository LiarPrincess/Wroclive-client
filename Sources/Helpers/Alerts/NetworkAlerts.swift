//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

class NetworkAlerts {

  /// Check network settings and try again
  static func showNoInternetAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Network.NoInternet
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.tryAgain, style: .default, result: ())]
    )
  }

  /// 'Check connection' alert and try again
  static func showConnectionErrorAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Network.ConnectionError
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.tryAgain, style: .default, result: ())]
    )
  }
}
