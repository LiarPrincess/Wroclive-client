//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum NetworkingError: Error {

  /// No internet connection
  case noInternet

  /// Unable to connect to server
  case connectionError

  /// Response received from server was not valid
  case invalidResponse
}
