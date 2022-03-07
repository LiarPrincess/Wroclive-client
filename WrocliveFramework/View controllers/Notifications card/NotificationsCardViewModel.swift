// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import Foundation
import PromiseKit

public protocol NotificationsCardViewModelDelegate: AnyObject {
  func showDetails(notification: Notification)
}

public protocol NotificationsCardViewType: AnyObject {
  func refresh()
  func showApiErrorAlert(error: ApiError)
}

public final class NotificationsCardViewModel: StoreSubscriber {

  internal private(set) var cells = [NotificationCellViewModel]()
  internal private(set) var isTableViewVisible = false
  internal private(set) var isLoadingViewVisible = false
  internal private(set) var isNoNotificationsViewVisible = false

  /// Time used for calculations of relative time offsets in cells.
  private let now: Date
  /// State of the `store.getNotificationsResponse`.
  private let getNotificationsState = StoreApiResponseTracker<[Notification]>()

  private let store: Store<AppState>
  private weak var view: NotificationsCardViewType?
  private weak var delegate: NotificationsCardViewModelDelegate?

  public init(store: Store<AppState>,
              delegate: NotificationsCardViewModelDelegate?,
              date: Date? = nil) {
    self.store = store
    self.delegate = delegate
    self.now = date ?? Date()
  }

  // MARK: - View

  public func setView(view: NotificationsCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - View input

  public func viewDidLoad() {
    self.dispatchGetNotificationsAction()
    // Will automatically call 'newState(state:)' which will call 'self.refreshView'.
    self.store.subscribe(self)
  }

  public func viewDidSelectItem(index: Int) {
    guard self.cells.indices.contains(index) else {
      return
    }

    let cell = self.cells[index]
    let notification = cell.notification
    self.delegate?.showDetails(notification: notification)
  }

  public func viewDidPressAlertTryAgainButton() {
    self.dispatchGetNotificationsAction()
  }

  // MARK: - Store subscriber

  private var needsRefreshView = false

  public func newState(state: AppState) {
    self.needsRefreshView = false

    self.handleNewNotifications(newState: state)

    if self.needsRefreshView {
      self.refreshView()
    }
  }

  private func handleNewNotifications(newState: AppState) {
    let response = newState.getNotificationsResponse
    let result = self.getNotificationsState.update(from: response)

    switch result {
    case .final:
      // We already got to the state we wanted. Ignore.
      break

    case .initialData(let notifications),
         .newData(let notifications):
      // We don't want any more updates.
      // We already got to the state we wanted.
      self.getNotificationsState.markAsFinal(state: notifications)

      if notifications.isEmpty {
        self.setVisibleView(view: .noNotificationsView)
        return
      }

      var viewModels = notifications.map { notification in
        NotificationCellViewModel(notification: notification, now: self.now)
      }

      // Bigger date -> later in list
      viewModels.sort { $0.notification.date > $1.notification.date }

      self.cells = viewModels
      self.setVisibleView(view: .tableView)
      self.needsRefreshView = true

    case .sameDataAsBefore:
      // Nothing to change.
      break

    case .initialError(let error),
         .newError(let error):
      // New error -> show it.
      self.view?.showApiErrorAlert(error: error)

    case .sameErrorAsBefore:
      // The same error as before. Nothing to do.
      break

    case .initialInProgres,
         .inProgres:
      self.setVisibleView(view: .loadingView)

    case .initialNone,
         .none:
      // Initial state, soon we will be 'inProgres'
      self.setVisibleView(view: .loadingView)
    }
  }

  private enum VisibleView: Equatable {
    case loadingView
    case noNotificationsView
    case tableView
  }

  /// Will set `needsRefreshView` if needed.
  private func setVisibleView(view: VisibleView) {
    let isTableViewVisible = view == .tableView
    let isLoadingViewVisible = view == .loadingView
    let isNoNotificationsViewVisible = view == .noNotificationsView

    self.needsRefreshView = self.needsRefreshView
      || isTableViewVisible != self.isTableViewVisible
      || isLoadingViewVisible != self.isLoadingViewVisible
      || isNoNotificationsViewVisible != self.isNoNotificationsViewVisible

    self.isTableViewVisible = isTableViewVisible
    self.isLoadingViewVisible = isLoadingViewVisible
    self.isNoNotificationsViewVisible = isNoNotificationsViewVisible
  }

  // MARK: - Helpers

  private func dispatchGetNotificationsAction() {
    self.store.dispatch(ApiMiddlewareActions.requestNotifications)
  }
}
