//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

// swiftlint:disable identifier_name
var Managers: Environment {
  return AppEnvironment.current
}

struct AppEnvironment {

  private static var stack: [Environment] = []

  static var current: Environment {
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
