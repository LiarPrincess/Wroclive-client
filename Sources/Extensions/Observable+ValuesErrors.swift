//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
