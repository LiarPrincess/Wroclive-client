//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManager: SearchManagerType {

  func getState() -> SearchState {
    let document = Managers.documents.read(.searchState)
    return document as? SearchState ?? SearchState(withSelected: .tram, lines: [])
  }

  func save(_ state: SearchState) {
    let document = DocumentData.searchState(value: state)
    Managers.documents.write(document)
  }
}
