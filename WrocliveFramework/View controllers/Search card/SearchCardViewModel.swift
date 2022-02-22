// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

public protocol SearchCardViewType: AnyObject {

  func refresh()

  // TODO: Bookmark flow is awkard, move to separate struct
  func showBookmarkNameInputAlert()
  func showBookmarkNoLineSelectedAlert()
  func showApiErrorAlert(error: ApiError)

  func close(animated: Bool)
}

public final class SearchCardViewModel: StoreSubscriber {

  public typealias Page = SearchCardState.Page

  internal private(set) var page: Page
  internal private(set) var isLineSelectorVisible: Bool
  internal private(set) var isLoadingViewVisible: Bool

  // swiftlint:disable:next trailing_closure
  internal private(set) lazy var lineSelectorViewModel = LineSelectorViewModel(
    initialPage: self.page,
    onPageTransition: { [weak self] page in self?.viewDidSelectPage(page: page) }
  )

  /// State with which we started.
  private let initialState: SearchCardState
  /// State of the `store.getLinesResponse`.
  private var getLinesState = StoreApiResponseTracker<[Line]>()

  private let store: Store<AppState>
  private let environment: Environment
  private weak var view: SearchCardViewType?

  // MARK: - Init

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment

    let storage = self.environment.storage
    self.initialState = storage.readSearchCardState() ?? SearchCardState.default

    self.page = self.initialState.page
    self.isLineSelectorVisible = false
    self.isLoadingViewVisible = false

    // This will have side-effect of calling the lazy init! (we do want that)
    let selectedLines = self.initialState.selectedLines
    self.lineSelectorViewModel.setSelectedLines(lines: selectedLines)
  }

  // MARK: - View

  public func setView(view: SearchCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - View input

  public func viewDidLoad() {
    self.dispatchGetLinesAction()
    // Will automatically call 'newState(state:)' which will call 'self.refreshView'.
    self.store.subscribe(self)
  }

  public func viewDidPressBookmarkButton() {
    let selectedLines = self.getSelectedLines()

    if selectedLines.isEmpty {
      self.view?.showBookmarkNoLineSelectedAlert()
    } else {
      self.view?.showBookmarkNameInputAlert()
    }
  }

  public func viewDidEnterBookmarkName(value: String) {
    let lines = self.getSelectedLines()
    self.store.dispatch(BookmarksAction.add(name: value, lines: lines))
  }

  public func viewDidPressSearchButton() {
    let lines = self.getSelectedLines()
    self.store.dispatch(TrackedLinesAction.startTracking(lines))
    self.view?.close(animated: true)
  }

  public func viewDidPressAlertTryAgainButton() {
    self.dispatchGetLinesAction()
  }

  public func viewDidSelectPage(page: Page) {
    self.setPage(page: page)
    self.refreshView()
  }

  public func viewDidDisappear() {
    let page = self.page
    let lines = self.getSelectedLines()
    let state = SearchCardState(page: page, selectedLines: lines)

    if state != self.initialState {
      self.environment.storage.writeSearchCardState(state)
    }
  }

  internal func getSelectedLines() -> [Line] {
    let selectedLines = self.lineSelectorViewModel.selectedLines
    return selectedLines.merge()
  }

  // MARK: - Store subscriber

  private var needsRefreshView = false

  public func newState(state: AppState) {
    self.needsRefreshView = false

    self.handleLineResponseChange(newState: state)

    if self.needsRefreshView {
      self.refreshView()
    }
  }

  private func handleLineResponseChange(newState: AppState) {
    let response = newState.getLinesResponse
    let result = self.getLinesState.update(from: response)

    switch result {
    case .final:
      // We already got to the state we wanted. Ignore.
      break

    case .initialData(let lines),
         .newData(let lines):
      if lines.isEmpty {
        self.setVisibleView(view: .loadingView)
        self.view?.showApiErrorAlert(error: .invalidResponse)
        return
      }

      // We don't want any more updates.
      // We already got to the state we wanted.
      self.getLinesState.markAsFinal(state: lines)

      self.lineSelectorViewModel.setLines(lines: lines)
      self.setVisibleView(view: .lineSelector)
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

  private enum VisibleView {
    case lineSelector
    case loadingView
  }

  /// Will set `needsRefreshView` if needed.
  private func setVisibleView(view: VisibleView) {
    let isLineSelectorVisible = view == .lineSelector
    let isLoadingViewVisible = view == .loadingView

    self.needsRefreshView = self.needsRefreshView
      || isLineSelectorVisible != self.isLineSelectorVisible
      || isLoadingViewVisible != self.isLoadingViewVisible

    self.isLineSelectorVisible = isLineSelectorVisible
    self.isLoadingViewVisible = isLoadingViewVisible
  }

  /// Will set `needsRefreshView` if needed.
  private func setPage(page: Page) {
    self.needsRefreshView = self.needsRefreshView
      || self.page != page
      || self.lineSelectorViewModel.page != page

    self.page = page
    self.lineSelectorViewModel.setPage(page: page)
  }

  // MARK: - Helpers

  private func dispatchGetLinesAction() {
    self.store.dispatch(ApiMiddlewareActions.requestLines)
  }
}
