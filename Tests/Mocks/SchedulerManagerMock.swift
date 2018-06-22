// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import RxSwift
@testable import Wroclive

class SchedulerManagerMock: SchedulerManagerType {
  var main:      SchedulerType
  var mainAsync: SchedulerType

  init(main: SchedulerType, mainAsync: SchedulerType) {
    self.main      = main
    self.mainAsync = mainAsync
  }
}
