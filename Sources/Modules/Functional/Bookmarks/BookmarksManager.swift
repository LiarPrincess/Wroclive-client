//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol BookmarksManager {

  /// Create new user-defined bookmark
  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark

  /// Retrieve all of the user-defined bookmarks
  func getAll() -> [Bookmark]

  /// Updates definitions of all of the provided bookmarks
  func save(_ bookmarks: [Bookmark])
}
