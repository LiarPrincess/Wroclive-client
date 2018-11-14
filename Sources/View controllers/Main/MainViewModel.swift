// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class MainViewModel {

  let disposeBag = DisposeBag()

  // MARK: - Inputs

  let didPressSearchButton:   AnyObserver<Void>
  let didPressBookmarkButton: AnyObserver<Void>
  let didPressSettingsButton: AnyObserver<Void>

  // MARK: - Outputs

  let mapViewModel: MapViewModel

  let openSearchCard:    Driver<Void>
  let openBookmarksCard: Driver<Void>
  let openSettingsCard:  Driver<Void>

  init(_ store: Store<AppState>, _ mapViewModel: MapViewModel) {
    self.mapViewModel = mapViewModel

    let _didPressSearchButton = PublishSubject<Void>()
    self.didPressSearchButton = _didPressSearchButton.asObserver()
    self.openSearchCard = _didPressSearchButton.asDriver(onErrorDriveWith: .never())

    let _didPressBookmarkButton = PublishSubject<Void>()
    self.didPressBookmarkButton = _didPressBookmarkButton.asObserver()
    self.openBookmarksCard = _didPressBookmarkButton.asDriver(onErrorDriveWith: .never())

    let _didPressSettingsButton = PublishSubject<Void>()
    self.didPressSettingsButton = _didPressSettingsButton.asObserver()
    self.openSettingsCard = _didPressSettingsButton.asDriver(onErrorDriveWith: .never())
  }
}
