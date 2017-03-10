//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - Actions

struct SetLineSelectionVisibility: Action {
  var visiblity: Bool

  init(_ visiblity: Bool) {
    self.visiblity = visiblity
  }
}

struct SetLineSelectionFilter: Action {
  var vehicleType: VehicleType

  init(_ vehicleType: VehicleType) {
    self.vehicleType = vehicleType
  }
}

//MARK: - Reducer

struct LineSelectionReducer: Reducer {

  func handleAction(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {

    case let action as SetLineSelectionVisibility:
      state.lineSelectionState.visible = action.visiblity

      //select .tram filter when we open the control
      if action.visiblity {
        state.lineSelectionState.vehicleTypeFilter = .tram
      }

    case let action as SetLineSelectionFilter:
      state.lineSelectionState.vehicleTypeFilter = action.vehicleType
      state.lineSelectionState.filteredLines = state.lineSelectionState.availableLines.filter { $0.type == action.vehicleType }

    default:
      break
    }

    return state
  }
  
}
