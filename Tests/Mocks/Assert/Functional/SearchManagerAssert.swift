//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerAssert: SearchManager {

  func saveState(_ state: SearchState) {
    assertNotCalled()
  }

  func getSavedState() -> SearchState {
    assertNotCalled()
  }
}
