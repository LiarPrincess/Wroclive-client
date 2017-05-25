//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class BookmarksDataSource: NSObject, UITableViewDataSource {

  //MARK: - Properties

  var bookmarks = [Bookmark]()

  //MARK: - Data source

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as BookmarkCell
    let bookmark = self.bookmarks[indexPath.row]

    cell.setUp(with: BookmarkCellViewModel(bookmark))
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
    }
  }

}
