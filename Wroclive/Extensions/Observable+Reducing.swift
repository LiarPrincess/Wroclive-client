// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import RxSwift

extension ObservableType {
  func reducing<A>(_ seed: A, apply: @escaping (A, Self.E) throws -> A) -> Observable<A> {
    return self
      .scan(seed, accumulator: apply)
      .startWith(seed)
  }
}
