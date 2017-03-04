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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarksViewControllerConstants.cellIdentifier, for: indexPath) as? BookmarkCell  else {
      fatalError("The dequeued cell is not an instance of BookmarkCell")
    }

    cell.labelName.font = UIFont.customPreferredFont(forTextStyle: .headline)
    cell.labelTramLines.font = UIFont.customPreferredFont(forTextStyle: .body)
    cell.labelBusLines.font  = UIFont.customPreferredFont(forTextStyle: .body)

    let bookmark = self.bookmarks[indexPath.row]
    cell.labelName.text = bookmark.name
    cell.labelTramLines.text = prepareBookmarkLabel(bookmark, for: .tram)
    cell.labelBusLines.text = prepareBookmarkLabel(bookmark, for: .bus)
    return cell
  }

  //MARK: - Methods

  private func prepareBookmarkLabel(_ bookmark: Bookmark, for vehicleType: VehicleType) -> String {
    return bookmark.lines.filter { $0.type == vehicleType } .map { $0.name }.joined(separator: "  ")
  }

}
