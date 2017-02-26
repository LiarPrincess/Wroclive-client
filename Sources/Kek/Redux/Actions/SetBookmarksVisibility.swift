//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import ReSwift

struct SetBookmarksVisibility: ApplicableAction {
  let visiblity: Bool

  init(_ visiblity: Bool) {
    self.visiblity = visiblity
  }

  func apply(state: AppState) -> AppState {
    var result = state
    result.bookmarksState.visible = self.visiblity
    return result
  }
}
