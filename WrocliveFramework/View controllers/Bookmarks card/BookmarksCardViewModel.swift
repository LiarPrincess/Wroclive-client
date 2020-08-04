// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

private typealias TextStyles = BookmarksCardConstants.TextStyles
private typealias Localization = Localizable.Bookmarks

public protocol BookmarksCardViewType: AnyObject {

  func setBookmarks(value: [Bookmark])

  func setIsTableViewVisible(value: Bool)
  func setIsPlaceholderVisible(value: Bool)

  func setIsEditing(value: Bool, animated: Bool)
  func setEditButtonText(value: NSAttributedString)

  func close(animated: Bool)
}

public final class BookmarksCardViewModel: StoreSubscriber {

  private let store: Store<AppState>

  /// State that is currently being presented.
  private var currentState: AppState?
  /// Are we currently editing the bookmark list?
  private var isEditing = false
  private weak var view: BookmarksCardViewType?

  public init(store: Store<AppState>) {
    self.store = store
  }

  public func setView(view: BookmarksCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.store.subscribe(self)

    // Refresh 'Edit' button
    self.setIsEditing(value: self.isEditing)
  }

  // MARK: - Input

  public func didSelectItem(index: Int) {
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

  public func didMoveItem(fromIndex: Int, toIndex: Int) {
    self.store.dispatch(BookmarksAction.move(from: fromIndex, to: toIndex))
  }

  public func didDeleteItem(index: Int) {
    self.store.dispatch(BookmarksAction.remove(at: index))
  }

  public func didPressEditButton() {
    self.setIsEditing(value: !self.isEditing)
  }

  private func setIsEditing(value: Bool) {
    let editButtonText = value ?
      NSAttributedString(string: Localization.Edit.done, attributes: TextStyles.Edit.done) :
      NSAttributedString(string: Localization.Edit.edit, attributes: TextStyles.Edit.edit)

    self.isEditing = value
    self.view?.setIsEditing(value: value, animated: true)
    self.view?.setEditButtonText(value: editButtonText)
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    defer { self.currentState = state }

    self.updateBookmarkListIfNeeded(newState: state)
  }

  private func updateBookmarkListIfNeeded(newState: AppState) {
    let new = newState.bookmarks
    let old = self.currentState?.bookmarks

    guard new != old else {
      return
    }

    self.view?.setBookmarks(value: new)

    let isTableVisible = new.any
    self.view?.setIsTableViewVisible(value: isTableVisible)
    self.view?.setIsPlaceholderVisible(value: !isTableVisible)
  }
}
