//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
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

func XCTAssertOperationCount(_ manager: SearchManagerMock, get: Int, save: Int, file: StaticString = #file, line: UInt = #line) {
  XCTAssertEqual(manager.getStateCount, get, file: file, line: line)
  XCTAssertEqual(manager.saveCount,    save, file: file, line: line)
}
