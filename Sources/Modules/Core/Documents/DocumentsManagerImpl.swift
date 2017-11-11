//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class DocumentsManagerImpl: DocumentsManager {

  func read(_ document: Document) -> Any? {
    let path = self.getDocumentFilePath(document)
    return NSKeyedUnarchiver.unarchiveObject(withFile: path)
  }

  func write(_ value: Any, as document: Document) {
    let path = self.getDocumentFilePath(document)
    NSKeyedArchiver.archiveRootObject(value, toFile: path)
  }

  private func getDocumentFilePath(_ document: Document) -> String {
    let filename = self.getDocumentFilename(document)
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(filename).path
  }

  private func getDocumentFilename(_ document: Document) -> String {
    switch document {
    case .bookmarks:   return "bookmarks"
    case .searchState: return "searchState"
    }
  }
}
