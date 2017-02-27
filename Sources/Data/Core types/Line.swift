//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

//MARK: - VehicleType

enum VehicleType {
  case tram
  case bus
}

//MARK: - Line

struct Line {
  let name: String
  let type: VehicleType
}

extension Line: CustomStringConvertible {
  var description: String { return "(\(self.name), \(self.type))" }
}

extension Line: CustomDebugStringConvertible {
  var debugDescription: String { return self.description }
}
