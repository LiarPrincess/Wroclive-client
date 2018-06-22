// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Result
import RxSwift

extension ObservableType where E: ResultProtocol {

  /// Filter values
  public func values() -> Observable<E.Value> {
    return self.flatMap { Observable.from(optional: $0.value) }
  }

  /// Filter errors
  public func errors() -> Observable<E.Error> {
    return self.flatMap { Observable.from(optional: $0.error) }
  }
}
