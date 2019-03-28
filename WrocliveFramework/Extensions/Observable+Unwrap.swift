// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import RxSwift
import RxCocoa

public extension ObservableType {
  func unwrap<T>() -> Observable<T> where E == T? {
    return self.flatMap { Observable.from(optional: $0) }
  }
}

public extension Driver {
  func unwrap<T>() -> Driver<T> where E == T? {
    return self.flatMap { Driver.from(optional: $0) }
  }
}
