// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest

/**
 Helper for `XCTAssertEqual` that will return comparison result.

 Can be used in following pattern to prevent `index out of bound` errors:
 ```Swift
 if XCTIfEqual(array.count, 2) {
   XCTAssertEqual(array[0], value0)
   XCTAssertEqual(array[1], value1)
 }
 ```

 - Parameters:
    - expression1: An expression of type T, where T is Equatable.
    - expression2: An expression of type T, where T is Equatable.
    - message: An optional description of the failure.
    - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
    - line: The line number on which failure occurred. Defaults to the line number on which this function was called.

 - Returns: Comparison result.
 */
public func XCTIfEqual<T>(_ expression1: @autoclosure () throws -> T,
                          _ expression2: @autoclosure () throws -> T,
                          _ message:     @autoclosure () -> String = "",
                          file: StaticString = #file,
                          line: UInt         = #line) -> Bool where T : Equatable {

  do {
    let lhs = try expression1()
    let rhs = try expression2()
    XCTAssertEqual(lhs, rhs, message, file: file, line: line)
    return lhs == rhs
  } catch {
    XCTFail(message(), file: file, line: line)
    return false
  }
}
