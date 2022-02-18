// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import PromiseKit

extension Promise {
  public func ensureOnMain() -> Promise<T> {
    return self.ensure(on: .main, flags: nil) {}
  }
}

extension Promise where T == Void {
  public static func value() -> Promise<Void> {
    return Promise.value(())
  }
}

extension Guarantee {
  public func ensureOnMain() -> Guarantee<T> {
    return self.get(on: .main, flags: nil) { _ in () }
  }
}
