//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol SearchManager {

  /// Save current state
  func saveState(_ state: SearchState)

  /// Retrieve the most recently saved state
  /// or default if no states were saved
  func getSavedState() -> SearchState
}
