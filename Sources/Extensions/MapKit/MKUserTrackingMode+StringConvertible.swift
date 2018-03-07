//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import MapKit

extension MKUserTrackingMode: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    switch self {
    case .none:              return "none"
    case .follow:            return "follow"
    case .followWithHeading: return "followWithHeading"
    }
  }

  public var debugDescription: String {
    return self.description
  }
}
