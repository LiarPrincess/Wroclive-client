// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

protocol SettingsCardViewModelOutput {

  /**
   - custom
   */
  var items: Driver<[SettingsSection]> { get }

  /**
   - self.selectedCell -> share
   */
  var showShareControl: Driver<Void> { get }

  /**
   - self.selectedCell -> rate
   */
  var showRateControl: Driver<Void> { get }

  /**
   - self.selectedCell -> about
   */
  var showAboutPage: Driver<Void> { get }
}
