//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift

// source: https://github.com/RxSwiftCommunity/RxSwiftExt

extension ObservableType {

  /**
   Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
   - returns: An observable sequence of non-optional elements
   */
  public func unwrap<T>() -> Observable<T> where E == T? {
    return self.flatMap { Observable.from(optional: $0) }
  }
}
