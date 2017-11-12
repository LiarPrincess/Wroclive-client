//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerMock: SearchManager {

  // MARK: - Properties

  private var state: SearchState

  // MARK: Init

  init(state: SearchState) {
    self.state = state
  }

  // MARK: SearchManager

  func saveState(_ state: SearchState) {
    self.state = state
  }

  func getSavedState() -> SearchState {
    return self.state
  }
}
