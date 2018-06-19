//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum UserLocationError: Error, Equatable {
  case permissionNotDetermined
  case permissionDenied
  case generalError
}
