//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum TrackingResult {
  case success(locations: [Vehicle])
  case error(error: Error)
}
