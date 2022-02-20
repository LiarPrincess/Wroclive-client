// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import Foundation
import PromiseKit

public protocol NotificationsCardViewType: AnyObject {
  func refresh()
  func showApiErrorAlert(error: ApiError)
  func close(animated: Bool)
}

public final class NotificationsCardViewModel: StoreSubscriber {

  internal private(set) var cells: [NotificationCellViewModel]
  internal private(set) var isTableViewVisible: Bool
  internal private(set) var isNoNotificationsViewVisible: Bool
  internal private(set) var isLoadingViewVisible: Bool

  /// Time used for calculations of relative time offsets in cells.
  private let now: Date
  /// Previous response, so we know how to react to new state.
  private var getNotificationsResponse: AppState.ApiResponseState<[Notification]>?

  private let store: Store<AppState>
  private weak var view: NotificationsCardViewType?

  public init(store: Store<AppState>, date: Date? = nil) {
    self.store = store
    self.cells = []
    self.isTableViewVisible = false
    self.isNoNotificationsViewVisible = false
    self.isLoadingViewVisible = false
    self.now = date ?? Date()

    self.store.subscribe(self)

    self.setVisibleView(view: .loadingView)
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

  // MARK: - View input

  public func viewDidLoad() {
    self.requestNotificationssFromApi()
  }

  public func viewDidPressAlertTryAgainButton() {
    self.requestNotificationssFromApi()
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    let newResponse = state.getNotificationsResponse
    defer { self.getNotificationsResponse = newResponse }

    switch newResponse {
    case .data(let notifications):
      self.handleResponseWithNotifications(notifications)

    case .error(let newError):
      // We just opened the card and the result of the previous opening was error.
      // Do nothing - we will fire our own request to override the error.
      guard let oldResponse = self.getNotificationsResponse else {
        break
      }

      // If previously we did not have an error -> just show new error
      guard let oldError = oldResponse.getError() else {
        self.view?.showApiErrorAlert(error: newError)
        break
      }

      // Otherwise we have to check if error changed
      if !ApiError.haveEqualType(oldError, newError) {
        self.view?.showApiErrorAlert(error: newError)
      }

    case .inProgress:
      // Leave it as it is
      break

    case .none:
      // Initial state, soon we will be 'inProgres'
      break
    }
  }

  private func handleResponseWithNotifications(_ notifications: [Notification]) {
    if notifications.isEmpty {
      self.setVisibleView(view: .noNotificationsView)
      self.refreshView()
      return
    }

    let noChanges = notifications.count == self.cells.count
      && zip(notifications, self.cells).allSatisfy { $0 == $1.notification }

    if noChanges {
      return
    }

    var viewModels = notifications.map { notification in
      NotificationCellViewModel(notification: notification, now: self.now)
    }

    // Bigger date -> later in list
    viewModels.sort { $0.notification.date > $1.notification.date }

    self.cells = viewModels
    self.setVisibleView(view: .tableView)
    self.refreshView()
  }

  private func requestNotificationssFromApi() {
    self.store.dispatch(ApiMiddlewareActions.requestNotifications)
  }

  // MARK: - Visible view

  private enum VisibleView: Equatable {
    case loadingView
    case noNotificationsView
    case tableView
  }

  private func setVisibleView(view: VisibleView) {
    self.isTableViewVisible = view == .tableView
    self.isNoNotificationsViewVisible = view == .noNotificationsView
    self.isLoadingViewVisible = view == .loadingView
  }
}
