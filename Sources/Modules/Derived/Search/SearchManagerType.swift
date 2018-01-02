//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol SearchManagerType {

  /// Retrieve the most recently saved state
  /// or default if no states were saved
  func getState() -> SearchState

  /// Save current state
  func save(_ state: SearchState)
}
