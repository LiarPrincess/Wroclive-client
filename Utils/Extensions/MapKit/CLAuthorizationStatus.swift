//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

//MARK: - AllowsLocalization

extension CLAuthorizationStatus {
  public var allowsLocalization: Bool { return self == .authorizedWhenInUse || self == .authorizedAlways }
}

//MARK: - CustomStringConvertible

extension CLAuthorizationStatus: CustomStringConvertible {
  public var description: String {
    get{
      switch self {
      case .notDetermined:
        return "notDetermined"

      case .authorizedAlways:
        return "authorizedAlways"
      case .authorizedWhenInUse:
        return "authorizedWhenInUse"

      case .denied:
        return "denied"
      case .restricted:
        return "restricted"
      }
    }
  }
}

//MARK: - CustomDebugStringConvertible

extension CLAuthorizationStatus: CustomDebugStringConvertible {
  public var debugDescription: String {
    return self.description
  }
}
