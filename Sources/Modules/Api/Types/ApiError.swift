//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum ApiError: Error, Equatable, Hashable {

  /// No internet connection
  case noInternet

  /// Response received from server was not valid
  case invalidResponse

  /// General error when cause cannot be determined
  case generalError
}
