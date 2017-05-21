//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class BookmarksDataSource: NSObject, UITableViewDataSource {

  //MARK: - Properties

  var bookmarks = [Bookmark]()

  //MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.identifier, for: indexPath) as? BookmarkCell  else {
      fatalError("The dequeued cell is not an instance of BookmarkCell")
    }

    let bookmark = self.bookmarks[indexPath.row]
    cell.bookmarkName.text = bookmark.name
    cell.tramLines.text = concatLineNames(bookmark.lines, ofType: .tram)
    cell.busLines.text = concatLineNames(bookmark.lines, ofType: .bus)
    return cell
  }

  //MARK: - Methods

  private func concatLineNames(_ lines: [Line], ofType lineType: LineType) -> String {
    return lines.filter { $0.type == lineType }
                .map { $0.name }
                .joined(separator: "  ")
  }

}
