//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DocumentsManagerImpl: DocumentsManager {

  func write(_ value: Any, as document: Document) {
    let path = self.createFilePath(document)
    NSKeyedArchiver.archiveRootObject(value, toFile: path)
  }

  func read(_ document: Document) -> Any? {
    let path = self.createFilePath(document)
    return NSKeyedUnarchiver.unarchiveObject(withFile: path)
  }

  private func createFilePath(_ document: Document) -> String {
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(document.filename).path
  }
}
