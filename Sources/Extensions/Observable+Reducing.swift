//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift

extension ObservableType {
  func reducing<A>(_ seed: A, apply: @escaping (A, Self.E) throws -> A) -> Observable<A> {
    return self
      .scan(seed, accumulator: apply)
      .startWith(seed)
  }
}
