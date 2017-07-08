//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarksDataSource: NSObject {

  // MARK: - Properties

  fileprivate(set) var bookmarks: [Bookmark]

  weak var delegate: BookmarksDataSourceDelegate?

  // MARK: - Init

  init(with bookmarks: [Bookmark], delegate: BookmarksDataSourceDelegate? = nil) {
    self.bookmarks = bookmarks.sorted { $0.order < $1.order }
    self.delegate  = delegate
  }

  // MARK: - Methods

  func bookmark(at indexPath: IndexPath) -> Bookmark? {
    guard indexPath.section == 0 else {
      return nil
    }

    guard indexPath.row < self.bookmarks.count else {
      return nil
    }

    return self.bookmarks[indexPath.row]
  }

  // MARK: - Delegate methods

  fileprivate func delegateDidChangedBookmarkCount() {
    delegate?.didChangedBookmarkCount(self)
  }

  fileprivate func delegateDidReorderBookmarks() {
    delegate?.didReorderBookmarks(self)
  }

}

// MARK: - UITableViewDataSource

extension BookmarksDataSource: UITableViewDataSource {

  // MARK: - Data

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(ofType: BookmarkCell.self, forIndexPath: indexPath)

    let bookmark  = self.bookmarks[indexPath.row]
    let viewModel = BookmarkCellViewModel(from: bookmark)

    cell.setUp(with: viewModel)
    return cell
  }

  // MARK: - Moving/reordering

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let bookmark = self.bookmarks.remove(at: sourceIndexPath.row)
    self.bookmarks.insert(bookmark, at: destinationIndexPath.row)
    self.recalculateBookmarkOrders()
    self.delegateDidReorderBookmarks()
  }

  // MARK: - Editing

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.bookmarks.remove(at: indexPath.row)
      self.recalculateBookmarkOrders()

      tableView.deleteRows(at: [indexPath], with: .automatic)
      self.delegateDidChangedBookmarkCount()
    }
  }

  // MARK: - Private

  private func recalculateBookmarkOrders() {
    self.bookmarks = self.bookmarks
      .enumerated()
      .map { (order, old) in
        return Bookmark(id: old.id, name: old.name, lines: old.lines, order: order + 1)
      }
  }

}
