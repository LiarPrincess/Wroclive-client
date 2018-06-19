//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

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
