// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

public protocol MainViewModelDelegate: MapViewModelDelegate {
  func openSearchCard()
  func openBookmarksCard()
  func openSettingsCard()
}

public final class MainViewModel {

  public let mapViewModel: MapViewModel
  private weak var delegate: MainViewModelDelegate?

  public init(store: Store<AppState>,
              environment: Environment,
              delegate: MainViewModelDelegate?) {
    self.mapViewModel = MapViewModel(store: store,
                                     environment: environment,
                                     delegate: delegate)

    self.delegate = delegate
  }

  public func didPressSearchButton() {
    self.delegate?.openSearchCard()
  }

  public func didPressBookmarkButton() {
    self.delegate?.openBookmarksCard()
  }

  public func didPressSettingsButton() {
    self.delegate?.openSettingsCard()
  }
}
