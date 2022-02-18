// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

private typealias Constants = BookmarksCard.Constants
private typealias Localization = Localizable.Bookmarks

public protocol BookmarksCardViewType: AnyObject {
  func refresh()
  func close(animated: Bool)
}

public final class BookmarksCardViewModel: StoreSubscriber {

  internal private(set) var cells: [BookmarksCellViewModel]
  internal private(set) var isTableViewVisible: Bool
  internal private(set) var isPlaceholderVisible: Bool
  internal private(set) var isEditing: Bool
  internal private(set) var editButtonText: NSAttributedString

  private let store: Store<AppState>
  private weak var view: BookmarksCardViewType?

  public init(store: Store<AppState>) {
    self.store = store
    self.cells = []
    self.isTableViewVisible = false
    self.isPlaceholderVisible = true
    self.isEditing = false
    self.editButtonText = Self.createEditButtonText(isEditing: false)

    self.store.subscribe(self)
  }

  // MARK: - View

  public func setView(view: BookmarksCardViewType) {
    assert(self.view == nil, "View was already assigned")
    self.view = view
    self.refreshView()
  }

  private func refreshView() {
    self.view?.refresh()
  }

  // MARK: - View input

  public func viewDidSelectItem(index: Int) {
    guard self.cells.indices.contains(index) else {
      return
    }

    let cell = self.cells[index]
    self.store.dispatch(TrackedLinesAction.startTracking(cell.bookmark.lines))

    self.view?.close(animated: true)
  }

  public func viewDidMoveItem(fromIndex: Int, toIndex: Int) {
    self.store.dispatch(BookmarksAction.move(from: fromIndex, to: toIndex))
  }

  public func viewDidDeleteItem(index: Int) {
    let action = BookmarksAction.remove(index: index)
    self.store.dispatch(action)
  }

  public func viewDidPressEditButton() {
    let newValue = !self.isEditing
    self.isEditing = newValue
    self.editButtonText = Self.createEditButtonText(isEditing: newValue)
    self.refreshView()
  }

  private static func createEditButtonText(isEditing: Bool) -> NSAttributedString {
    // swiftlint:disable:next type_name
    typealias L = Localization.Edit
    typealias Text = Constants.Header.Edit

    return isEditing ?
      NSAttributedString(string: L.done, attributes: Text.doneAttributes) :
      NSAttributedString(string: L.edit, attributes: Text.editAttributes)
  }

  // MARK: - Store subscriber

  public func newState(state: AppState) {
    let bookmarks = state.bookmarks

    let noChanges = bookmarks.count == self.cells.count
      && zip(bookmarks, self.cells).allSatisfy { $0 == $1.bookmark }

    if noChanges {
      return
    }

    let viewModels = bookmarks.map(BookmarksCellViewModel.init(bookmark:))

    let isTableVisible = viewModels.any
    self.cells = viewModels
    self.isTableViewVisible = isTableVisible
    self.isPlaceholderVisible = !isTableVisible

    self.refreshView()
  }
}
