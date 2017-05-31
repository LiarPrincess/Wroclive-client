//
//  Created by Michal Matuszczyk
//  Copyright © Michal Matuszczyk. All rights reserved.
//

import Foundation
import ReSwift

//MARK: - State

struct LineSelectionState {
  var selectedLines = [Line]()
  var availableLines = [Line]()
}

//MARK: - Actions

struct SelectLines: Action {
  let lines: [Line]

  init(_ lines: [Line]) {
    self.lines = lines
  }
}

//MARK: - Reducer

struct LineSelectionReducer {

  func handleAction(action: Action, state: LineSelectionState) -> LineSelectionState {
    var state = state

    switch action {

    case let action as SelectLines:
      state.selectedLines = action.lines

    default:
      break
    }
    
    return state
  }
  
}
