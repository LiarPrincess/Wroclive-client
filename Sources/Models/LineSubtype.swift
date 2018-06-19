//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

enum LineSubtype: Int, Codable, Equatable {
  case regular
  case express
  case peakHour
  case suburban
  case zone
  case limited
  case temporary
  case night
}
