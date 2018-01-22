//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import RxSwift

protocol MapManagerType {

  // MARK: - Map type

  /// Preferred map type
  var mapType: Observable<MapType> { get }

  /// Change preferred map type
  func setMapType(_ mapType: MapType)

  // MARK: - Tracking

  /// Last obtained tracking result
  var result: TrackingResult { get }

  /// Start tracking new set of lines
  func start(_ lines: [Line])

  /// Pause tracking, so that new notifications will not be issued
  func pause()

  /// Resume tracking
  func resume()
}
