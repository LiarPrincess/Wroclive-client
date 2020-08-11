// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import WrocliveFramework

class ExtensionCollectionAnyTests: XCTestCase {

  func test_arrayModifications_changeReturnedValue() {
    var data = [Int]()
    XCTAssertFalse(data.any)

    data.append(5)
    XCTAssertTrue(data.any)

    data.append(7)
    data.append(9)
    XCTAssertTrue(data.any)

    data.removeAll()
    XCTAssertFalse(data.any)
  }

  func test_doesNot_iterateCollection() {
    let collection = IntCollection()
    XCTAssertTrue(collection.any)
    XCTAssertEqual(collection.subscriptCallCount, 0)
    XCTAssertEqual(collection.indexAfterCallCount, 0)
  }
}

private class IntCollection: Collection {

  typealias Index = Int

  var startIndex: Index { return 0 }
  var endIndex:   Index { return Int.max }

  private(set) var subscriptCallCount:  Int = 0
  private(set) var indexAfterCallCount: Int = 0

  subscript(position: Index) -> Int {
    self.subscriptCallCount += 1
    return Swift.max(self.startIndex, position)
  }

  func index(after i: Index) -> Index {
    self.indexAfterCallCount += 1
    return i + 1
  }
}
