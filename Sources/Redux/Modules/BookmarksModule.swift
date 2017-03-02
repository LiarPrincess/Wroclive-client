//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - Actions

struct SetBookmarksVisibility: Action {
  var visiblity: Bool

  init(_ visiblity: Bool) {
    self.visiblity = visiblity
  }
}

//MARK: - Reducer

struct BookmarksReducer: Reducer {

  func handleAction(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
      
    case let action as SetBookmarksVisibility:
      state.bookmarksState.visible = action.visiblity

    default:
      break
    }

    return state
  }

}
