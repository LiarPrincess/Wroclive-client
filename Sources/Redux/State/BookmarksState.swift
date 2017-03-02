//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - BookmarksState

struct BookmarksState: StateType {
  var visible = false
  var bookmarks = [Bookmark]()
}
