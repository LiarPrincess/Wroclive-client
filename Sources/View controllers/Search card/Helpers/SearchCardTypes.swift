//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import Result
import RxSwift

typealias SearchCardApiResponse = Observable<Result<[Line], SearchCardApiError>>

enum SearchCardApiError: Error {
  case noInternet
  case generalError
}

enum SearchCardBookmarkAlert {
  case nameInput
  case noLinesSelected
}
