// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift

extension ObservableType where E: EventConvertible {

  public func elements() -> Observable<E.ElementType> {
    return self
      .filter { $0.event.element != nil }
      .map { $0.event.element! }
  }

  public func errors() -> Observable<Swift.Error> {
    return self
      .filter { $0.event.error != nil }
      .map { $0.event.error! }
  }
}
