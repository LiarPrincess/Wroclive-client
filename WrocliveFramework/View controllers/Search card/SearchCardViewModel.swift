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

  internal private(set) var page: LineType
  internal private(set) var isLineSelectorVisible: Bool
  internal private(set) var isPlaceholderVisible: Bool
  internal private(set) lazy var lineSelectorViewModel = LineSelectorViewModel(
    initialPage: self.page,
    onPageTransition: { [weak self] page in self?.setPage(page: page) }
  )

  private let initialState: SearchCardState

  /// Previous response, so we know how to react to new state.
  private var getLinesResponse: AppState.ApiResponseState<[Line]>?

  private let store: Store<AppState>
  private let environment: Environment
  private weak var view: SearchCardViewType?

  internal var selectedLines: LineSelectorViewModel.SelectedLines {
    return self.lineSelectorViewModel.selectedLines
  }

  // MARK: - Init

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment

    let storage = self.environment.storage
    self.initialState = storage.readSearchCardState() ?? SearchCardState.default

    self.page = self.initialState.page
    self.isLineSelectorVisible = false
    self.isPlaceholderVisible = true

    // This will have side-effect of calling the lazy init! (we do want that)
    let selectedLines = self.initialState.selectedLines
    self.lineSelectorViewModel.setSelectedLines(lines: selectedLines)

    self.store.subscribe(self)
  }

  private func setPage(page: LineType) {
    self.page = page
    self.lineSelectorViewModel.setPage(page: page)
    self.refreshView()
  }

  // MARK: - View

  public func setView(view: SearchCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - View input

  public func viewDidPressBookmarkButton() {
    let selectedLines = self.selectedLines

    if selectedLines.isAnyLineSelected {
      self.view?.showBookmarkNameInputAlert()
    } else {
      self.view?.showBookmarkNoLineSelectedAlert()
    }
  }

  public func viewDidEnterBookmarkName(value: String) {
    let lines = self.selectedLines.merge()
    self.store.dispatch(BookmarksAction.add(name: value, lines: lines))
  }

  public func viewDidPressSearchButton() {
    let lines = self.selectedLines.merge()
    self.store.dispatch(TrackedLinesAction.startTracking(lines))
    self.view?.close(animated: true)
  }

  public func viewDidPressAlertTryAgainButton() {
    self.requestLinesFromApi()
  }

  public func viewDidSelectPage(page: LineType) {
    self.setPage(page: page)
  }

  public func viewDidDisappear() {
    let page = self.page
    let lines = self.selectedLines.merge()
    let state = SearchCardState(page: page, selectedLines: lines)

    if state != self.initialState {
      self.environment.storage.writeSearchCardState(state)
    }
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    self.handleLineRequestChange(newState: state)
    self.refreshView()
  }

  private func handleLineRequestChange(newState: AppState) {
    let new = newState.getLinesResponse
    let old = self.getLinesResponse
    defer { self.getLinesResponse = new }

    switch new {
    case .data(let newLines):
      let oldLines = old?.getData()
      if newLines != oldLines {
        if newLines.isEmpty {
          self.view?.showApiErrorAlert(error: .invalidResponse)
        } else {
          self.lineSelectorViewModel.setLines(lines: newLines)
          self.setIsLineSelectorVisible(value: true)
        }
      }

    case .error(let newError):
      // If previously we did not have an error -> just show new error
      guard let oldError = old?.getError() else {
        self.view?.showApiErrorAlert(error: newError)
        return
      }

      // Otherwise we have to check if error changed
      switch (oldError, newError) {
        case (.invalidResponse, .invalidResponse),
             (.reachabilityError, .reachabilityError),
             (.otherError, .otherError):
        break
      default:
        self.view?.showApiErrorAlert(error: newError)
      }

    case .inProgress:
      // Leave it as it is
      break

    case .none:
      let isTheSameAsPrevious = old?.isNone ?? false
      if !isTheSameAsPrevious {
        self.requestLinesFromApi()
        self.setIsLineSelectorVisible(value: false)
      }
    }
  }

  private func requestLinesFromApi() {
    self.store.dispatch(ApiMiddlewareActions.requestLines)
  }

  private func setIsLineSelectorVisible(value: Bool) {
    self.isLineSelectorVisible = value
    self.isPlaceholderVisible = !value
  }
}
