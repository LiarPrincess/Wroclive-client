//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarksDataSource: NSObject {

  //MARK: - Properties

  weak var delegate: BookmarksDataSourceDelegate?

  fileprivate var viewModels: [BookmarkCellViewModel]

  var bookmarks: [Bookmark] { return self.viewModels.map { $0.bookmark } }

  //MARK: - Init

  init(with bookmarks: [Bookmark], delegate: BookmarksDataSourceDelegate? = nil) {
    self.viewModels = bookmarks.map { BookmarkCellViewModel(from: $0) }
    self.delegate   = delegate
  }

  //MARK: - Methods

  fileprivate func delegateDidUpdateBookmarkCount() {
    delegate?.didUpdateBookmarkCount(self)
  }

  fileprivate func delegateDidReorderBookmarks() {
    delegate?.didReorderBookmarks(self)
  }

}

//MARK: - UITableViewDataSource

extension BookmarksDataSource: UITableViewDataSource {

  //MARK: - Data

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(ofType: BookmarkCell.self, forIndexPath: indexPath)
    let viewModel = self.viewModels[indexPath.row]

    cell.setUp(with: viewModel)
    return cell
  }

  //MARK: - Moving/reordering

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let bookmark = self.viewModels.remove(at: sourceIndexPath.row)
    self.viewModels.insert(bookmark, at: destinationIndexPath.row)
    self.delegateDidReorderBookmarks()
  }

  //MARK: - Editing

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.viewModels.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      self.delegateDidUpdateBookmarkCount()
    }
  }
}
