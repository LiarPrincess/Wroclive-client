// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

extension AppState {

  public static func createMiddleware(environment: Environment) -> [Middleware<AppState>] {
    // Order is important!
    return [
      Middlewares.logging(environment: environment),
      Middlewares.api(environment: environment),
      Middlewares.persistency(environment: environment),
      Middlewares.networkActivityIndicator(environment: environment)
    ]
  }
}

// Namespace to avoid polluting global.
internal enum Middlewares {}
