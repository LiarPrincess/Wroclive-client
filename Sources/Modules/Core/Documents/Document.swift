//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum Document {
  case bookmarks
  case searchState
}

enum DocumentData {
  case bookmarks  (value: [Bookmark])
  case searchState(value: SearchState)

  var document: Document {
    switch self {
    case .bookmarks:   return .bookmarks
    case .searchState: return .searchState
    }
  }

  var data: Any {
    switch self {
    case let .bookmarks(value: value):   return value
    case let .searchState(value: value): return value
    }
  }
}
