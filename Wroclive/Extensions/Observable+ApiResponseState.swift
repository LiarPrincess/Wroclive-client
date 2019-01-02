// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
  func data<Data>() -> Observable<Data> where Self.E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Observable<Data> in
      switch response {
      case let .data(payload): return Observable.just(payload)
      case .none, .inProgress, .error: return Observable.never()
      }
    }
  }

  func errors<Data>() -> Observable<Error> where Self.E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Observable<Error> in
      switch response {
      case let .error(error): return Observable.just(error)
      case .none, .inProgress, .data: return Observable.never()
      }
    }
  }
}

extension Driver {
  func data<Data>() -> Driver<Data> where E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Driver<Data> in
      switch response {
      case let .data(payload): return Driver.just(payload)
      case .none, .inProgress, .error: return Driver.never()
      }
    }
  }

  func errors<Data>() -> Driver<Error> where E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Driver<Error> in
      switch response {
      case let .error(error): return Driver.just(error)
      case .none, .inProgress, .data: return Driver.never()
      }
    }
  }
}
