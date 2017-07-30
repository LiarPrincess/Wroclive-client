//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

struct NetworkManagerConstants {

  struct Endpoints {
    static let lines     = "http://192.168.1.100:8080/lines"
    static let locations = "http://192.168.1.100:8080/locations"
  }

  static let timeout: TimeInterval = 10.0
}
