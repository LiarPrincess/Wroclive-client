//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol DocumentsManagerType {

  // Read document from file
  func read(_ document: Document) -> Any?

  /// Save document to file
  func write(_ documentData: DocumentData)
}
