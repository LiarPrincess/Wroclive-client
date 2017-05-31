//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import XCGLogger

let logger: XCGLogger = {
  let log = XCGLogger(identifier: "com.kekapp", includeDefaultDestinations: false)

  let consoleDestination = ConsoleDestination(identifier: log.identifier + ".console")
  consoleDestination.outputLevel = .debug
  consoleDestination.showLogIdentifier = false
  consoleDestination.showFunctionName = false
  consoleDestination.showThreadName = true
  consoleDestination.showLevel = true
  consoleDestination.showFileName = false
  consoleDestination.showLineNumber = false
  consoleDestination.showDate = true
  log.add(destination: consoleDestination)

  log.logAppDetails()
  return log
}()
