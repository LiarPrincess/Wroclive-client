//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum UserLocationError: Error {

  // User has not yet made a choice whether to allow to use his location
  case permissionNotDetermined

  // User has denied location authorization
  case permissionDenied

  /// E.g. GPS error/timeout
  case generalError
}
