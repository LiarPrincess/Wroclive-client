//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum Document {
  case bookmarks
  case searchCardState
}

enum DocumentData {
  case bookmarks(value: [Bookmark])
  case searchCardState(value: SearchCardState)

  var document: Document {
    switch self {
    case .bookmarks:       return .bookmarks
    case .searchCardState: return .searchCardState
    }
  }

  var data: Any {
    switch self {
    case let .bookmarks(value: value):       return value
    case let .searchCardState(value: value): return value
    }
  }
}
