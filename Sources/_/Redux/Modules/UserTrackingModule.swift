//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import MapKit
import ReSwift

//MARK: - Actions

struct SetUserTrackingMode: Action {
  var trackingMode: MKUserTrackingMode

  init(_ trackingMode: MKUserTrackingMode) {
    self.trackingMode = trackingMode
  }
}

struct ToggleUserTrackingMode: Action { }

//MARK: - Reducer

struct UserTrackingReducer: Reducer {

  func handleAction(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {

    case let action as SetUserTrackingMode:
      state.trackingMode = action.trackingMode

    case _ as ToggleUserTrackingMode:
      state.trackingMode = self.nextTrackingMode(after: state.trackingMode)

    default:
      break
    }

    return state
  }

  private func nextTrackingMode(after trackingMode: MKUserTrackingMode) -> MKUserTrackingMode {
    switch trackingMode {
    case .none:
      return .follow
    case .follow:
      return .followWithHeading
    case .followWithHeading:
      return .none
    }
  }

}
