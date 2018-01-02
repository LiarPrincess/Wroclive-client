//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
@testable import Wroclive

class TrackingManagerMock: TrackingManagerType {

  private(set) var requestedLines = [[Line]]()

  lazy var result: TrackingResult = .success(locations: [])

  func start(_ lines: [Line]) {
    self.requestedLines.append(lines)
  }

  func pause()  { }
  func resume() { }
}
