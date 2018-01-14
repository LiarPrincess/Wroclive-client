//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

class BookmarkAlerts {

  /// Bookmark cannot be created as no line was selected
  static func showNoLinesSelectedAlert(in parent: UIViewController) -> Observable<Void> {
    typealias Localization = Localizable.Alert.Bookmark.NoLinesSelected
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.ok, style: .default, result: ())],
      in:      parent
    )
  }

  /// Prompt for bookmark name
  static func showNameInputAlert(in parent: UIViewController) -> Observable<String?> {
    typealias Localization = Localizable.Alert.Bookmark.NameInput
    return AlertCreator.createTextInputAlert(
      title:       Localization.title,
      message:     Localization.message,
      placeholder: Localization.placeholder,
      confirm:     AlertButton(title: Localization.save,   style: .default, result: ()),
      cancel:      AlertButton(title: Localization.cancel, style: .cancel,  result: ()),
      in:          parent
    )
  }
}
