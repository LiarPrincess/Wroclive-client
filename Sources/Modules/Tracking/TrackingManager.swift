//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum TrackingResult {
  case success(locations: [Vehicle])
  case error(error: Error)
}

protocol TrackingManager {
  var result: TrackingResult { get }

  func start(_ lines: [Line])
  func pause()
  func resume()
}
