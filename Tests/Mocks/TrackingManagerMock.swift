//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class TrackingManagerMock: TrackingManagerType {

  private(set) var trackedLines = [[Line]]()

  private(set) var startCount  = 0
  private(set) var pauseCount  = 0
  private(set) var resumeCount = 0

  lazy var result: TrackingResult = .success(locations: [])

  func start(_ lines: [Line]) {
    self.startCount += 1
    self.trackedLines.append(lines)
  }

  func pause()  { self.pauseCount  += 1 }
  func resume() { self.resumeCount += 1 }
}
