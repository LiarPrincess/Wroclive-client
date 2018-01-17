//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class SearchManagerMock: SearchManagerType {

  var state = SearchCardState(page: .tram, selectedLines: [])

  private(set) var getStateCount = 0
  private(set) var saveCount     = 0

  func getState() -> SearchCardState {
    self.getStateCount += 1
    return self.state
  }

  func save(_ state: SearchCardState) {
    self.saveCount += 1
    self.state = state
  }
}
