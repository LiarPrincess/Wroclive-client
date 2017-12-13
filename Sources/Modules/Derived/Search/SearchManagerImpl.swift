//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManagerImpl: SearchManager {

  func getSavedState() -> SearchState {
    let document = Managers.documents.read(.searchState)
    return document as? SearchState ?? SearchState(withSelected: .tram, lines: [])
  }

  func saveState(_ state: SearchState) {
    let document = DocumentData.searchState(value: state)
    Managers.documents.write(document)
  }
}
