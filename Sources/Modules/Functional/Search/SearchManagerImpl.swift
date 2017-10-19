//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerImpl: SearchManager {

  // MARK: - Properties

  private let filename = "searchState"

  private lazy var state: SearchState = {
    let fileContent = Managers.fileSystem.read(from: .documents, filename: self.filename)
    return fileContent as? SearchState ?? SearchState(withSelected: .tram, lines: [])
  }()

  // MARK: - StorageManagerProtocol

  func saveState(_ state: SearchState) {
    guard state != self.state else { return }

    self.state = state
    Managers.fileSystem.write(self.state, to: .documents, filename: self.filename)
  }

  func getSavedState() -> SearchState {
    return self.state
  }
}
