//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit

//MARK: - CustomStringConvertible

extension MKUserTrackingMode: CustomStringConvertible {
  public var description: String {
    get{
      switch self {
      case .none:
        return "none"
      case .follow:
        return "follow"
      case .followWithHeading:
        return "followWithHeading"
      }
    }
  }
}

//MARK: - CustomDebugStringConvertible

extension MKUserTrackingMode: CustomDebugStringConvertible {
  public var debugDescription: String {
    return self.description
  }
}
