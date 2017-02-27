//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import MapKit

//MARK: - VechicleType

enum VechicleType {
  case tram
  case bus
}

//MARK: - Line

struct Line {
  let name: String
  let vechicleType: VechicleType
}

//MARK: - VechiclePosition

struct VechiclePosition {
  let line: Line
  let position: CLLocationCoordinate2D
}

//MARK: - Bookmark

struct Bookmark {
  let name: String
  let lines: [Line]
}
