// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log

public protocol LogManagerType {
  var app:       OSLog { get }
  var redux:     OSLog { get }
  var mapUpdate: OSLog { get }
  var storage:   OSLog { get }
  var api:       OSLog { get }
}

public struct LogManager: LogManagerType {

  public let app: OSLog
  public let redux: OSLog
  public let mapUpdate: OSLog
  public let storage: OSLog
  public let api: OSLog

  public init(bundle: BundleManagerType) {
    func createLog(category: String) -> OSLog {
      return OSLog(subsystem: bundle.identifier, category: category)
    }

    self.app = createLog(category: "app")
    self.redux = createLog(category: "redux")
    self.mapUpdate = createLog(category: "map-update")
    self.storage = createLog(category: "storage")
    self.api = createLog(category: "api")
  }
}
