// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import os.log
@testable import WrocliveFramework

class LogManagerMock: LogManagerType {

  var app: OSLog {
    fatalError("LogManagerMock.app is not implmented")
  }

  var redux: OSLog {
    fatalError("LogManagerMock.redux is not implmented")
  }

  var mapUpdate: OSLog {
    fatalError("LogManagerMock.mapUpdate is not implmented")
  }

  var storage: OSLog {
    fatalError("LogManagerMock.storage is not implmented")
  }
}
