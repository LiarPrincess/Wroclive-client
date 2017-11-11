//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CachedDocumentsManagerImpl: DocumentsManager {

  private let innerManager: DocumentsManager
  private var cache:        [Document: Any]  = [:]

  init(_ documentManager: DocumentsManager) {
    self.innerManager = documentManager
  }

  func read(_ document: Document) -> Any? {
    if let cachedValue = self.cache[document] {
      return cachedValue
    }

    let value = self.innerManager.read(document)
    self.cache[document] = value
    return value
  }

  func write(_ value: Any, as document: Document) {
    self.cache[document] = value
    self.innerManager.write(value, as: document)
  }
}
