//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol BookmarksManager {

  /// Adds new user-defined bookmark
  @discardableResult
  func addNew(name: String, lines: [Line]) -> Bookmark

  /// Updates definitions of all of the provided bookmarks
  func save(_ bookmarks: [Bookmark])

  /// Returns all of the user-defined bookmarks
  func getAll() -> [Bookmark]

}
