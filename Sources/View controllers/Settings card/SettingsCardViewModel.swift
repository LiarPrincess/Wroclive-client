// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

typealias SettingsSection = RxSectionModel<SettingsSectionType, SettingsCellType>

class SettingsCardViewModel {

  // MARK: - Inputs

  let didSelectItem: AnyObserver<IndexPath>

  // MARK: - Outputs

  let items: Driver<[SettingsSection]> = {
    let generalSection = SettingsSection(model: .general, items: [.share, .rate, .about])

    return Observable.just([generalSection])
      .asDriver(onErrorJustReturn: [])
  }()

  let showShareControl: Driver<Void>
  let showRateControl:  Driver<Void>
  let showAboutPage:    Driver<Void>

  // MARK: - Init

  init() {
    let _didSelectItem = PublishSubject<IndexPath>()
    self.didSelectItem = _didSelectItem.asObserver()

    let selectedCell = _didSelectItem
      .withLatestFrom(self.items) { index, items in items[index] }
      .share()

    self.showShareControl = selectedCell.showControl(.share)
    self.showRateControl  = selectedCell.showControl(.rate)
    self.showAboutPage    = selectedCell.showControl(.about)
  }
}

// MARK: - Helpers

private extension Observable where E == SettingsCellType {
  func showControl(_ cell: SettingsCellType) -> Driver<Void> {
    return self
      .filter { $0 == cell }
      .map { _ in () }
      .asDriver(onErrorDriveWith: .never())
  }
}
