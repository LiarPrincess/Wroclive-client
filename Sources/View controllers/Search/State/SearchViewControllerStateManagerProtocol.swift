//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

protocol SearchViewControllerStateManagerProtocol {
  func saveState(state: SearchViewControllerState)
  func getState() -> SearchViewControllerState
}
