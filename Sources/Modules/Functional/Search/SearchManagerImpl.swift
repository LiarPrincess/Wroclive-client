//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerImpl: SearchManager {

  func saveState(_ state: SearchState) {
    Managers.documents.write(state, as: .searchState)
  }

  func getSavedState() -> SearchState {
    let fileContent = Managers.documents.read(.searchState)
    return fileContent as? SearchState ?? SearchState(withSelected: .tram, lines: [])
  }
}
