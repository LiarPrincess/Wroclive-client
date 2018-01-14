//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Result
import RxSwift

typealias ApiResponse<Data> = Observable<Result<Data, ApiError>>

class SearchCardNetworkAdapter {
  static func getAvailableLines() -> ApiResponse<[Line]> {
    return ApiResponse.create { observer -> Disposable in
      Managers.api.getAvailableLines()
        .tap { result in
          switch result {
          case let .fulfilled(lines): observer.onNext(.success(lines))
          case let .rejected(error):  observer.onNext(.failure(toApiError(error)))
          }
          observer.onCompleted()
        }
      return Disposables.create()
    }
  }
}

private func toApiError(_ error: Error) -> ApiError {
  return error as? ApiError ?? ApiError.connectionError
}
