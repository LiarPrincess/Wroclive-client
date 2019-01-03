// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import ReSwift

// swiftlint:disable implicit_return

public typealias MiddlewareFactoryArgs = (dispatch: DispatchFunction, getState: () -> AppState?, next: DispatchFunction, action: Action)
public typealias MiddlewareFactory     = (MiddlewareFactoryArgs) -> ()

/// Helper function to minimalize indentation in middleware definitions
public func createSingleMiddleware(_ factory: @escaping MiddlewareFactory) -> Middleware<AppState> {
  return { dispatch, getState in
    return { next in
      return { action in
        let args = (dispatch, getState, next, action)
        factory(args)
      }
    }
  }
}
