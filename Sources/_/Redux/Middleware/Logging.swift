//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import ReSwift

let loggingMiddleware: Middleware = { dispatch, getState in
  return { next in
    return { action in
      log.info(action)
      return next(action)
    }
  }
}
