//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Result
import RxSwift

enum SearchCardApiError: Error {
  case noInternet
  case generalError
}

typealias SearchCardApiResponse = Observable<Result<[Line], SearchCardApiError>>
