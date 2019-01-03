// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

public enum Document {
  case bookmarks
  case searchCardState
}

public enum DocumentData {
  case bookmarks([Bookmark])
  case searchCardState(SearchCardState)

  public var document: Document {
    switch self {
    case .bookmarks:       return .bookmarks
    case .searchCardState: return .searchCardState
    }
  }

  public var data: Any {
    switch self {
    case let .bookmarks(value):       return value
    case let .searchCardState(value): return value
    }
  }
}
