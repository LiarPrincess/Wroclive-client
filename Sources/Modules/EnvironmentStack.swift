// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

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
