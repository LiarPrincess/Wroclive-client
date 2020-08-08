// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

private typealias Constants = BookmarksCardConstants
private typealias Localization = Localizable.Bookmarks

public protocol BookmarksCardViewType: AnyObject {
  func refresh()
  func close(animated: Bool)
}

public final class BookmarksCardViewModel: StoreSubscriber {

  internal private(set) var bookmarks: [Bookmark] {
    didSet { self.needsViewRefresh = true }
  }

  internal private(set) var isTableViewVisible: Bool {
    didSet { self.needsViewRefresh = true }
  }

  internal private(set) var isPlaceholderVisible: Bool {
    didSet { self.needsViewRefresh = true }
  }

  internal private(set) var isEditing: Bool {
    didSet { self.needsViewRefresh = true }
  }

  internal private(set) var editButtonText: NSAttributedString {
     didSet { self.needsViewRefresh = true }
   }

  private let store: Store<AppState>
  /// State that is currently being presented.
  private var currentState: AppState?
  private weak var view: BookmarksCardViewType?

  public init(store: Store<AppState>) {
    self.store = store
    self.bookmarks = []
    self.isTableViewVisible = false
    self.isPlaceholderVisible = true
    self.isEditing = false
    self.editButtonText = Self.createEditButtonText(isEditing: false)
    self.store.subscribe(self)
  }

  // MARK: - View

  private var needsViewRefresh = false

  public func setView(view: BookmarksCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
    self.needsViewRefresh = false
  }

  // MARK: - Input

  public func viewDidSelectItem(index: Int) {
    guard let state = self.currentState else {
      return
    }

    let bookmarks = state.bookmarks
    guard bookmarks.indices.contains(index) else {
      return
    }

    let bookmark = bookmarks[index]
    self.store.dispatch(TrackedLinesAction.startTracking(bookmark.lines))

    self.view?.close(animated: true)
  }

  public func viewDidMoveItem(fromIndex: Int, toIndex: Int) {
    self.store.dispatch(BookmarksAction.move(from: fromIndex, to: toIndex))
  }

  public func viewDidDeleteItem(index: Int) {
    self.store.dispatch(BookmarksAction.remove(at: index))
  }

  public func viewDidPressEditButton() {
    let newValue = !self.isEditing
    self.isEditing = newValue
    self.editButtonText = Self.createEditButtonText(isEditing: newValue)
    self.refreshView()
  }

  private static func createEditButtonText(isEditing: Bool) -> NSAttributedString {
    typealias L = Localization.Edit
    typealias Text = Constants.Header.Edit

    return isEditing ?
      NSAttributedString(string: L.done, attributes: Text.doneAttributes) :
      NSAttributedString(string: L.edit, attributes: Text.editAttributes)
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    defer { self.currentState = state }

    self.updateBookmarkListIfNeeded(newState: state)
    self.refreshView()
  }

  private func updateBookmarkListIfNeeded(newState: AppState) {
    let new = newState.bookmarks
    let old = self.currentState?.bookmarks

    guard new != old else {
      return
    }

    let isTableVisible = new.any
    self.bookmarks = new
    self.isTableViewVisible = isTableVisible
    self.isPlaceholderVisible = !isTableVisible
  }
}
