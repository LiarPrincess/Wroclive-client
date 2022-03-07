// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias Localization = Localizable.RelativeDate

private let second = 1.0
private let minute = 60.0 * second
private let hour = 60.0 * minute
private let day = 24.0 * hour

/// Not ultra precise, but good enough.
///
/// 'RelativeDateTimeFormatter' is only available in iOS 13.
/// 'Date.RelativeFormatStyle' is only available in iOS 15.
public struct RelativeDateFormatter {

  public init() {}

  public func string(present: Date, past: Date) -> String {
    let interval = self.interval(present: present, past: past)
    switch interval {
    case .future: return "Future"
    case .now: return "Now"
    case .minutes(let count): return String(describing: count) + "m"
    case .hours(let count): return String(describing: count) + "h"
    case .days(let count): return String(describing: count) + "d"
    }
  }

  public func localizedStringWithNowInsteadOfFuture(present: Date,
                                                    past: Date) -> String {
    let interval = self.interval(present: present, past: past)
    switch interval {
    case .future,
         .now:
      return Localization.now
    case .minutes(let count):
      return String(describing: count) + Localization.minuteShort
    case .hours(let count):
      return String(describing: count) + Localization.hourShort
    case .days(let count):
      return String(describing: count) + Localization.dayShort
    }
  }

  private enum Interval {
    case future
    case now
    case minutes(Int)
    case hours(Int)
    case days(Int)
  }

  private func interval(present: Date, past: Date) -> Interval {
    let present1970 = present.timeIntervalSince1970
    let past1970 = past.timeIntervalSince1970

    guard present1970 > past1970 else {
      return .future
    }

    let diff = present1970 - past1970

    if diff < minute {
      return .now
    }

    if diff < hour {
      let minuteCount = Int(diff / minute)
      return .minutes(minuteCount)
    }

    if diff < 1 * day {
      let hourCount = Int(diff / hour)
      return .hours(hourCount)
    }

    let dayCount = Int(diff / day)
    return .days(dayCount)
  }
}
