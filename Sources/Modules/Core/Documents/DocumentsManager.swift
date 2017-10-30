//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum Document: String {
  case bookmarks
  case searchState

  var filename: String {
    switch self {
    case .bookmarks:   return "bookmarks"
    case .searchState: return "searchState"
    }
  }
}

protocol DocumentsManager {

  /// Save object to file
  func write(_ value: Any, as document: Document)

  // Read object from file
  func read(_ document: Document) -> Any?
}
