//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol BookmarksManagerType {

  /// Create new user-defined bookmark
  func addNew(_ bookmark: Bookmark)

  /// Retrieve all of the user-defined bookmarks
  func getAll() -> [Bookmark]

  /// Updates definitions of all of the provided bookmarks
  func save(_ bookmarks: [Bookmark])
}
