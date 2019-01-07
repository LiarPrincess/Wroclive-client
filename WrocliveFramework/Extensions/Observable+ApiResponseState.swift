// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
  public func data<Data>() -> Observable<Data> where Self.E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Observable<Data> in
      switch response {
      case let .data(payload): return Observable.just(payload)
      case .none, .inProgress, .error: return Observable.never()
      }
    }
  }

  public func errors<Data>() -> Observable<ApiError> where Self.E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Observable<ApiError> in
      switch response {
      case let .error(error): return Observable.just(error)
      case .none, .inProgress, .data: return Observable.never()
      }
    }
  }
}

extension Driver {
  public func data<Data>() -> Driver<Data> where E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Driver<Data> in
      switch response {
      case let .data(payload): return Driver.just(payload)
      case .none, .inProgress, .error: return Driver.never()
      }
    }
  }

  public func errors<Data>() -> Driver<ApiError> where E == ApiResponseState<Data> {
    return self.flatMapLatest { response -> Driver<ApiError> in
      switch response {
      case let .error(error): return Driver.just(error)
      case .none, .inProgress, .data: return Driver.never()
      }
    }
  }
}
