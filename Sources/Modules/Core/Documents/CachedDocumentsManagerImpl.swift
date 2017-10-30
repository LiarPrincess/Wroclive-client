//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CachedDocumentsManagerImpl: DocumentsManagerImpl {

  private var cache: [Document: Any] = [:]

  override func write(_ value: Any, as document: Document) {
    self.cache[document] = value
    return super.write(value, as: document)
  }

  override func read(_ document: Document) -> Any? {
    if let cachedValue = self.cache[document] {
      return cachedValue
    }

    let value = super.read(document)
    self.cache[document] = value
    return value
  }
}
