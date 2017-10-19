//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class FileSystemManagerImpl: FileSystemManager {

  func write(_ value: Any, to location: FileSystemLocation, filename: String) {
    let filePath = self.createFilePath(location: location, filename: filename)
    NSKeyedArchiver.archiveRootObject(value, toFile: filePath)
  }

  func read(from location: FileSystemLocation, filename: String) -> Any? {
    let filePath = self.createFilePath(location: location, filename: filename)
    return NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
  }

  private func createFilePath(location: FileSystemLocation, filename: String) -> String {
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent(filename).path
  }
}
