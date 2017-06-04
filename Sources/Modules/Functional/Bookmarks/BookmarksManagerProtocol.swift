//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol BookmarksManagerProtocol {
  func add(bookmark: Bookmark)
  func getAll() -> [Bookmark]
  func save(bookmarks: [Bookmark])
}
