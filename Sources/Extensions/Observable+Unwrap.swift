//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import RxSwift

extension ObservableType {
  public func unwrap<T>() -> Observable<T> where E == T? {
    return self.flatMap { Observable.from(optional: $0) }
  }
}
