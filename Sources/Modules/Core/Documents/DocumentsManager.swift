//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum Document: String {
  case bookmarks
  case searchState
}

protocol DocumentsManager {

  // Read document from file
  func read(_ document: Document) -> Any?

  /// Save document to file
  func write(_ value: Any, as document: Document)
}
