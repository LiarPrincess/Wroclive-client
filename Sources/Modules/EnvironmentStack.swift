//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct EnvironmentStack {

  private static var stack: [Environment] = []

  static var current: Environment {
    precondition(stack.any, "Attempting to use empty environment stack.")
    return stack.last!
  }

  static func push(_ environment: Environment) {
    stack.append(environment)
  }

  static func pop() {
    precondition(stack.count > 1, "Attempting to remove last entry in environment stack.")
    _ = stack.popLast()
  }
}
