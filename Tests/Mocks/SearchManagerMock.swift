//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import XCTest
import Foundation
@testable import Wroclive

// swiftlint:disable identifier_name

class SearchManagerMock: SearchManagerType {

  var _state = SearchCardState(page: .tram, selectedLines: [])

  fileprivate var getStateCount = 0
  fileprivate var saveCount     = 0

  func getState() -> SearchCardState {
    self.getStateCount += 1
    return self._state
  }

  func save(_ state: SearchCardState) {
    self.saveCount += 1
    self._state = state
  }
}

func XCTAssertOperationCount(_ manager: SearchManagerMock,
                             get:  Int,
                             save: Int,
                             file: StaticString = #file,
                             line: UInt         = #line) {
  XCTAssertEqual(manager.getStateCount, get, file: file, line: line)
  XCTAssertEqual(manager.saveCount,    save, file: file, line: line)
}
