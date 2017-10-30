//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerImpl: SearchManager {

  // MARK: - Properties

  private lazy var state: SearchState = {
    let fileContent = Managers.documents.read(.searchState)
    return fileContent as? SearchState ?? SearchState(withSelected: .tram, lines: [])
  }()

  // MARK: - StorageManagerProtocol

  func saveState(_ state: SearchState) {
    guard state != self.state else { return }

    self.state = state
    Managers.documents.write(self.state, as: .searchState)
  }

  func getSavedState() -> SearchState {
    return self.state
  }
}
