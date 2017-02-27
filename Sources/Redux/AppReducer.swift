//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {

  func handleAction(action: Action, state: AppState?) -> AppState {
    guard let action = action as? ApplicableAction else {
      fatalError("State changing action must be applicable!")
    }

    guard let state = state else {
      fatalError("Undefined state as an action reciever!")
    }

    return action.apply(state: state)
  }

}
