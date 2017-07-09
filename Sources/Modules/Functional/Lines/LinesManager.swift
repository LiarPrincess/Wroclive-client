//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

protocol LinesManager {

  /// Retrieve all of the lines.
  /// May involve network request.
  func getAll() -> [Line]

}
