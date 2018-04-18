//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

typealias Managers = AppEnvironment

struct AppEnvironment {

  // MARK: Managers

  static var bundle:       BundleManagerType       { return current.bundle       }
  static var device:       DeviceManagerType       { return current.device       }
  static var network:      NetworkManagerType      { return current.network      }
  static var userLocation: UserLocationManagerType { return current.userLocation }
  static var documents:    DocumentsManagerType    { return current.documents    }
  static var debug:        DebugManagerType        { return current.debug        }

  static var theme:     ThemeManagerType     { return current.theme     }
  static var api:       ApiManagerType       { return current.api       }
  static var search:    SearchManagerType    { return current.search    }
  static var bookmarks: BookmarksManagerType { return current.bookmarks }
  static var map:       MapManagerType       { return current.map       }

  // MARK: Stack

  private static var stack: [Environment] = []

  private static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    precondition(stack.any, "Attempting to clear empty environment stack.")
    precondition(stack.count > 1, "Attempting to illegaly clear environment stack.")
    _ = stack.popLast()
  }
}
