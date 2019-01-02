// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import Wroclive

class ExtensionCollectionGroupTests: XCTestCase {

  func test_empty_returnsEmptyGrouping() {
    let data = [Int]()
    let collection = IntCollection(data)
    let result = collection.group { $0 }

    XCTAssertEqual(result.count, 0)
    XCTAssertEqual(collection.subscriptCallCount, data.count)
    XCTAssertEqual(collection.indexAfterCallCount, data.count)
  }

  func test_singleElement_returnsSingleGrouping() {
    let data = [5]
    let collection = IntCollection(data)
    let result = collection.group { $0 }

    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result[5], [5])
    XCTAssertEqual(collection.subscriptCallCount, data.count)
    XCTAssertEqual(collection.indexAfterCallCount, data.count)
  }

  func test_collection_withSingleGroup_returnsSingleGrouping() {
    let data = [5, 7, 5, 7, 9]
    let collection = IntCollection(data)
    let result = collection.group { _ in 11 }

    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result[11], [5, 7, 5, 7, 9])
    XCTAssertEqual(collection.subscriptCallCount, data.count)
    XCTAssertEqual(collection.indexAfterCallCount, data.count)
  }

  func test_collection_withMultipleGroups_returnsMultipleGroupings() {
    let data = [5, 7, 5, 7, 9]
    let collection = IntCollection(data)
    let result = collection.group { $0 }

    XCTAssertEqual(result.count, 3)
    XCTAssertEqual(result[5], [5, 5])
    XCTAssertEqual(result[7], [7, 7])
    XCTAssertEqual(result[9], [9])
    XCTAssertEqual(collection.subscriptCallCount, data.count)
    XCTAssertEqual(collection.indexAfterCallCount, data.count)
  }
}

private class IntCollection: Collection {

  let data: [Int]

  init(_ data: [Int]) {
    self.data = data
  }

  typealias Index = Array<Int>.Index

  var startIndex: Index { return self.data.startIndex }
  var endIndex:   Index { return self.data.endIndex }

  private(set) var subscriptCallCount:  Int = 0
  private(set) var indexAfterCallCount: Int = 0

  subscript(position: Index) -> Int {
    self.subscriptCallCount += 1
    return self.data[position]
  }

  func index(after i: Index) -> Index {
    self.indexAfterCallCount += 1
    return self.data.index(after: i)
  }
}
