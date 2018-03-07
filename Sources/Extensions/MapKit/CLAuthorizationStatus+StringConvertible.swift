//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import MapKit

extension CLAuthorizationStatus: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    switch self {
    case .notDetermined:       return "notDetermined"
    case .restricted:          return "restricted"
    case .denied:              return "denied"
    case .authorizedAlways:    return "authorizedAlways"
    case .authorizedWhenInUse: return "authorizedWhenInUse"
    }
  }

  public var debugDescription: String {
    return self.description
  }
}
