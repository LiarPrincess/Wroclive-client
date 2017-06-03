//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol BookmarksManagerProtocol {
  func getBookmarks() -> [Bookmark]
  func saveBookmarks(_ bookmarks: [Bookmark])
}
