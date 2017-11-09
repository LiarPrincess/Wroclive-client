//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DocumentsManagerAssert: DocumentsManager {

  func write(_ value: Any, as document: Document) {
    assertNotCalled()
  }

  func read(_ document: Document) -> Any? {
    assertNotCalled()
  }

  private func createFilePath(_ document: Document) -> String {
    assertNotCalled()
  }
}
