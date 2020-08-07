// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

public protocol SearchCardViewType: AnyObject {
  func setIsLineSelectorVisible(value: Bool)
  func setIsPlaceholderVisible(value: Bool)

  // TODO: Bookmark flow is awkard, move to separate struct
  func showBookmarkNameInputAlert()
  func showBookmarkNoLineSelectedAlert()
  func showApiErrorAlert(error: ApiError)

  func close(animated: Bool)
}

public final class SearchCardViewModel: StoreSubscriber {

  private let store: Store<AppState>
  private let environment: Environment

  /// State that is currently being presented.
  private var currentState: AppState?
  private weak var view: SearchCardViewType?

  internal let lineTypeSelectorViewModel: LineTypeSelectorViewModel
  internal let lineSelectorViewModel: LineSelectorViewModel

  private var selectedLines: [Line]? {
    return self.currentState?.searchCardState.selectedLines
  }

  public init(store: Store<AppState>, environment: Environment) {
    self.store = store
    self.environment = environment

    self.lineTypeSelectorViewModel = LineTypeSelectorViewModel(
      onPageSelected: { store.dispatch(SearchCardStateAction.selectPage($0)) }
    )

    self.lineSelectorViewModel = LineSelectorViewModel(
      onPageTransition: { store.dispatch(SearchCardStateAction.selectPage($0)) },
      onLineSelected: { store.dispatch(SearchCardStateAction.selectLine($0)) },
      onLineDeselected: { store.dispatch(SearchCardStateAction.deselectLine($0)) }
    )
  }

  public func setView(view: SearchCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.store.subscribe(self)
  }

  // MARK: - Input

  public func didPressBookmarkButton() {
    guard let selectedLines = self.selectedLines else {
      return
    }

    if selectedLines.any {
      self.view?.showBookmarkNameInputAlert()
    } else {
      self.view?.showBookmarkNoLineSelectedAlert()
    }
  }

  public func didEnterBookmarkName(value: String) {
    let selectedLines = self.selectedLines ?? []
    self.store.dispatch(BookmarksAction.add(name: value, lines: selectedLines))
  }

  public func didPressSearchButton() {
    let selectedLines = self.selectedLines ?? []
    self.store.dispatch(TrackedLinesAction.startTracking(selectedLines))

    self.view?.close(animated: true)
  }

  public func didPressAlertTryAgainButton() {
    self.requestLinesFromApi()
  }

  // MARK: - Delegates

  internal func lineTypeSelectorViewModel(didSelectPage page: LineType) {
    self.store.dispatch(SearchCardStateAction.selectPage(page))
  }

  internal func lineSelectorViewModel(didSelectPage page: LineType) {
    self.store.dispatch(SearchCardStateAction.selectPage(page))
  }

  internal func lineSelectorViewModel(didSelectLine line: Line) {
    self.store.dispatch(SearchCardStateAction.selectLine(line))
  }

  internal func lineSelectorViewModel(didDeselectLine line: Line) {
    self.store.dispatch(SearchCardStateAction.deselectLine(line))
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    defer { self.currentState = state }

    self.updatePageIfNeeded(newState: state)
    self.handleLineRequestChange(newState: state)
  }

  private func updatePageIfNeeded(newState: AppState) {
    let new = newState.searchCardState.page
    let old = self.currentState?.searchCardState.page

    if new != old {
      self.lineSelectorViewModel.setPage(page: new)
      self.lineTypeSelectorViewModel.setPage(page: new)
    }
  }

  private func handleSelectedLinesChange(newState: AppState) {
    let new = newState.searchCardState.selectedLines
    let old = self.currentState?.searchCardState.selectedLines

    if new != old {
      self.lineSelectorViewModel.setSelectedLines(lines: new)
    }
  }

  private func handleLineRequestChange(newState: AppState) {
    let new = newState.getLinesResponse
    let old = self.currentState?.getLinesResponse

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
      let isTheSameAsPrevious = old?.isNone ?? true
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
    self.view?.setIsLineSelectorVisible(value: value)
    self.view?.setIsPlaceholderVisible(value: !value)
  }
}
