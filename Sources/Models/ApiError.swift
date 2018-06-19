//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum ApiError: Error, Equatable {
  case noInternet
  case invalidResponse
  case generalError
}
