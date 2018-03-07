//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

class LocationAlerts {

  /// Prompt for authorization change in settings
  static func showDeniedLocationAuthorizationAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Location.Denied
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [
        AlertButton(title: Localization.settings, style: .default, result: ()),
        AlertButton(title: Localization.ok,       style: .default, result: ())
      ]
    )
  }

  /// Notify that it is not possible to show user location
  static func showGloballyDeniedLocationAuthorizationAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Location.GloballyDenied
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.ok, style: .default, result: ())]
    )
  }
}
