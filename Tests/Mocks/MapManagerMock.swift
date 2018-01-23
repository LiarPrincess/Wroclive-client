//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import RxSwift
import Result
@testable import Wroclive

class MapManagerMock: MapManagerType {

  // MARK: - Map type

  private(set) var setMapTypeCount = 0

  let mapTypeSource = Variable(MapType.standard)
  lazy var mapType: Observable<MapType> = self.mapTypeSource.asObservable()

  func setMapType(_ mapType: MapType) {
    self.setMapTypeCount += 1
  }

  // MARK: - Tracking

  private(set) var trackedLines = [[Line]]()

  private(set) var startTrackingCount  = 0
  private(set) var resumeTrackingCount = 0
  private(set) var pauseTrackingCount  = 0

  let vehicleLocationsSource = Variable(Result<[Vehicle], ApiError>.success([Vehicle]()))
  lazy var vehicleLocations: ApiResponse<[Vehicle]> = self.vehicleLocationsSource.asObservable()

  func startTracking(_ lines: [Line]) {
    self.startTrackingCount += 1
    self.trackedLines.append(lines)
  }

  func resumeTracking() { self.resumeTrackingCount += 1 }
  func pauseTracking()  { self.pauseTrackingCount  += 1 }
}
