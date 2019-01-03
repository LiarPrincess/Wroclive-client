// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift

public enum BookmarkAlerts {

  /// Bookmark cannot be created as no line was selected
  public static func showNoLinesSelectedAlert() -> Observable<Void> {
    typealias Localization = Localizable.Alert.Bookmark.NoLinesSelected
    return AlertCreator.createAlert(
      title:   Localization.title,
      message: Localization.message,
      buttons: [AlertButton(title: Localization.ok, style: .default, result: ())]
    )
  }

  /// Prompt for bookmark name
  public static func showNameInputAlert() -> Observable<String?> {
    typealias Localization = Localizable.Alert.Bookmark.NameInput
    return AlertCreator.createTextInputAlert(
      title:       Localization.title,
      message:     Localization.message,
      placeholder: Localization.placeholder,
      confirm:     AlertButton(title: Localization.save,   style: .default, result: ()),
      cancel:      AlertButton(title: Localization.cancel, style: .cancel,  result: ())
    )
  }
}
