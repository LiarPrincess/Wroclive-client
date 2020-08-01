// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

extension String {

  public static var empty: String {
    return ""
  }

  public func indices(of substrings: [String]) -> [NSRange] {
    let nsSelf = NSString(string: self)
    let length = nsSelf.length

    // swiftlint:disable force_try
    let regexExpr = substrings.joined(separator: "|")
    let regex = try! NSRegularExpression(pattern: regexExpr, options: [.caseInsensitive])

    return regex
      .matches(in: self, options: [], range: NSRange(location: 0, length: length))
      .map { $0.range }
  }
}
