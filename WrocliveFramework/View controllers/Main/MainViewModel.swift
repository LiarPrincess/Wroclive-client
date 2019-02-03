// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

public final class MainViewModel {

  public let disposeBag = DisposeBag()

  // MARK: - Inputs

  public let didPressSearchButton:   AnyObserver<Void>
  public let didPressBookmarkButton: AnyObserver<Void>
  public let didPressSettingsButton: AnyObserver<Void>

  // MARK: - Outputs

  public let mapViewModel: MapViewModel

  public let openSearchCard:    Driver<Void>
  public let openBookmarksCard: Driver<Void>
  public let openSettingsCard:  Driver<Void>

  public init(_ store: Store<AppState>) {
    self.mapViewModel = MapViewModel(store)

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
