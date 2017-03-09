//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - LineSelectionState

struct LineSelectionState {
  var visible = false

  var vehicleTypeFilter: VehicleType = .tram
  var filteredLines = [Line]()

  var availableLines = [Line]()
}
