// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

typealias SettingsSection = RxSectionModel<SettingsSectionType, SettingsCellType>

class SettingsCardViewModel {

  // MARK: - Inputs

  let itemSelected: AnyObserver<IndexPath>

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
    let _itemSelected = PublishSubject<IndexPath>()
    self.itemSelected = _itemSelected.asObserver()

    let selectedCell = _itemSelected
      .withLatestFrom(self.items) { $1[$0] }
      .share()

    self.showShareControl = selectedCell.filter(.share).asDriver(onErrorDriveWith: .never())
    self.showRateControl  = selectedCell.filter(.rate) .asDriver(onErrorDriveWith: .never())
    self.showAboutPage    = selectedCell.filter(.about).asDriver(onErrorDriveWith: .never())
  }
}

// MARK: - Helpers

private extension Observable where E == SettingsCellType {
  func filter(_ cell: SettingsCellType) -> Observable<Void> {
    return self.filter { $0 == cell }.map { _ in () }
  }
}
