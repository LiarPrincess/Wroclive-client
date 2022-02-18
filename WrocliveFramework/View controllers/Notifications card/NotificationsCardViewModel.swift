// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

public protocol NotificationsCardViewType: AnyObject {
  func refresh()
  func close(animated: Bool)
}

public final class NotificationsCardViewModel: StoreSubscriber {

  private let store: Store<AppState>
  private weak var view: NotificationsCardViewType?

  public init(store: Store<AppState>) {
    self.store = store

    self.store.subscribe(self)
  }

  // MARK: - View

  public func setView(view: NotificationsCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) { }
}
