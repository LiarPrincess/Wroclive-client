// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

// TODO: Finish
public final class MainViewModel {

  public let mapViewModel: MapViewModel

  public init(store: Store<AppState>, environment: Environment) {
    self.mapViewModel = MapViewModel(store: store, environment: environment)
  }

  public func didPressSearchButton() {
//    let _didPressSearchButton = PublishSubject<Void>()
//    self.didPressSearchButton = _didPressSearchButton.asObserver()
//    self.openSearchCard = _didPressSearchButton.asDriver(onErrorDriveWith: .never())
  }

  public func didPressBookmarkButton() {
//    let _didPressBookmarkButton = PublishSubject<Void>()
//    self.didPressBookmarkButton = _didPressBookmarkButton.asObserver()
//    self.openBookmarksCard = _didPressBookmarkButton.asDriver(onErrorDriveWith: .never())
  }

  public func didPressSettingsButton() {
//    let _didPressSettingsButton = PublishSubject<Void>()
//    self.didPressSettingsButton = _didPressSettingsButton.asObserver()
//    self.openSettingsCard = _didPressSettingsButton.asDriver(onErrorDriveWith: .never())
  }
}
