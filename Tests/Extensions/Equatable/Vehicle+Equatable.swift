//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

@testable import Wroclive

extension Vehicle: Equatable {
  public static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
    return true
      && lhs.id        == rhs.id
      && lhs.line      == rhs.line
      // we actually can do this, even though following are floating points:
      && lhs.latitude  == rhs.latitude
      && lhs.longitude == rhs.longitude
      && lhs.angle     == rhs.angle
  }
}
