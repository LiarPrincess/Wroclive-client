//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class SearchManagerMock: SearchManagerType {

  var searchState = SearchState(withSelected: .tram, lines: [])

  private(set) var getStateCount = 0
  private(set) var saveCount     = 0

  func getState() -> SearchState {
    self.getStateCount += 1
    return self.searchState
  }

  func save(_ state: SearchState) {
    self.saveCount += 1
    self.searchState = state
  }
}
