// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
