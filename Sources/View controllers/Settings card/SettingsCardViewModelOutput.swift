//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
