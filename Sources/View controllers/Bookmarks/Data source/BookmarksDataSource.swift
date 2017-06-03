//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarksDataSource: NSObject {

  //MARK: - Properties

  var bookmarks = [Bookmark]()
  weak var delegate: BookmarksDataSourceDelegate?

  //MARK: - Methods

  fileprivate func delegateDidChangeRowCount() {
    delegate?.bookmarksDataSource(self, didChangeRowCount: self.bookmarks.count)
  }

}

//MARK: - UITableViewDataSource

extension BookmarksDataSource: UITableViewDataSource {

  //MARK: - Data

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.delegateDidChangeRowCount()
    return self.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(ofType: BookmarkCell.self, forIndexPath: indexPath)
    let bookmark = self.bookmarks[indexPath.row]

    cell.setUp(with: BookmarkCellViewModel(from: bookmark))
    return cell
  }

  //MARK: - Moving/reordering

  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let bookmark = self.bookmarks.remove(at: sourceIndexPath.row)
    self.bookmarks.insert(bookmark, at: destinationIndexPath.row)
    BookmarksManager.instance.saveBookmarks(self.bookmarks)
  }

  //MARK: - Editing

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.bookmarks.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      BookmarksManager.instance.saveBookmarks(self.bookmarks)
      
      self.delegateDidChangeRowCount()
    }
  }
}
