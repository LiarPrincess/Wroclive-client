// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

public enum BookmarkAlerts {

  /// Bookmark cannot be created as no line was selected
  public static func showNoLinesSelectedAlert() -> Promise<Void> {
    typealias L = Localizable.Alert.Bookmark.NoLinesSelected
    return AlertCreator.create(
      title:   L.title,
      message: L.message,
      buttons: [
        AlertCreator.Button(title: L.ok, style: .default, result: ())
      ]
    )
  }

  /// Prompt for bookmark name
  public static func showNameInputAlert() -> Promise<String?> {
    typealias L = Localizable.Alert.Bookmark.NameInput
    return AlertCreator.createWithTextInput(
      title:       L.title,
      message:     L.message,
      placeholder: L.placeholder,
      confirm:     AlertCreator.TextInputButton(title: L.save,   style: .default),
      cancel:      AlertCreator.TextInputButton(title: L.cancel, style: .cancel)
    )
  }
}
