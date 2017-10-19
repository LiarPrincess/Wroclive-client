//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum FileSystemLocation {
  case documents
}

protocol FileSystemManager {

  /// Save object to file
  func write(_ value: Any, to location: FileSystemLocation, filename: String)

  // Read object from file
  func read(from location: FileSystemLocation, filename: String) -> Any?
}
