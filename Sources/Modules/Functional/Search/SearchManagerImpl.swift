//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerImpl: SearchManager {

  // MARK: - Properties

  private lazy var state: SearchState = {
    return NSKeyedUnarchiver.unarchiveObject(withFile: self.archive.path) as? SearchState
      ?? SearchState(withSelected: .tram, lines: [])
  }()

  private lazy var archive: URL = {
    let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsDirectory.appendingPathComponent("search")
  }()

  // MARK: - StorageManagerProtocol

  func saveState(_ state: SearchState) {
    if state != self.state {
      NSKeyedArchiver.archiveRootObject(state, toFile: self.archive.path)
    }

    self.state = state
  }

  func getSavedState() -> SearchState {
    return self.state
  }
}
