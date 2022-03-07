// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

// Not all of the date formats are supported, but we do not need more.
private var iso8601Formater: ISO8601DateFormatter {
  let result = ISO8601DateFormatter()
  result.formatOptions.insert(.withFractionalSeconds)
  return result
}

extension Date {

  /// Parse something like `2022-02-17T06:09:32.000Z`.
  public init?(iso8601: String) {
    if let value = iso8601Formater.date(from: iso8601) {
      self = value
    } else {
      return nil
    }
  }
}
