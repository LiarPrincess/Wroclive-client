//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift

// source: https://github.com/RxSwiftCommunity/RxSwiftExt

public enum FilterMap<Result> {
  case ignore
  case map(Result)

  fileprivate var value: Result? {
    switch self {
    case .ignore:         return nil
    case .map(let value): return value
    }
  }
}

extension ObservableType {

  /**
   Filters or Maps values from the source.
   - The returned Observable will error and complete with the source.
   - `next` values will be output according to the `transform` callback result:
   - returning `.ignore` will filter the value out of the returned Observable
   - returning `.map(newValue)` will propagate newValue through the returned Observable.
   */
  public func filterMap<T>(_ transform: @escaping (E) -> FilterMap<T>) -> Observable<T> {
    return self.flatMap { Observable.from(optional: transform($0).value) }
  }
}
