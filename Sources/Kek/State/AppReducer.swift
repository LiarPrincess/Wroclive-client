//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {

  func handleAction(action: Action, state: AppState?) -> AppState {
    guard let action = action as? ApplicableAction else {
      fatalError("")
    }

    guard let state = state else {
      fatalError("")
    }

    return action.apply(state: state)
  }

}
