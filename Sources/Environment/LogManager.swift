// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log

protocol LogManagerType {
  var app:       OSLog { get }
  var redux:     OSLog { get }
  var mapUpdate: OSLog { get }
  var storage:   OSLog { get }
}

// sourcery: manager
// We cannot use `os_log` inside manager as this would capture incorrect data
class LogManager: LogManagerType {

  lazy var app:       OSLog = { self.createLog(category: "app") }()
  lazy var redux:     OSLog = { self.createLog(category: "redux") }()
  lazy var mapUpdate: OSLog = { self.createLog(category: "map-update") }()
  lazy var storage:   OSLog = { self.createLog(category: "storage") }()

  private func createLog(category: String) -> OSLog {
    return OSLog(subsystem: AppEnvironment.bundle.identifier, category: category)
  }
}
