// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

/// React to a new data from store.
/// Basically a link between stateless `Redux` and statefull `UI`.
public final class StoreStateTracker<Data: Equatable> {

  public private(set) var currentValue: Data?

  public enum UpdateResult {
    /// We just started, and got our 1st `Data`.
    case initial(Data)
    case sameAsBefore(Data)
    case changed(new: Data, old: Data)
  }

  public func update(from new: Data) -> UpdateResult {
    defer { self.currentValue = new }

    guard let old = self.currentValue else {
      return .initial(new)
    }

    let isSameAsBefore = new == old
    return isSameAsBefore ? .sameAsBefore(new) : .changed(new: new, old: old)
  }
}
