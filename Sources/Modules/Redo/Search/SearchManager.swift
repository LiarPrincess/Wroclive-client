//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchManager: SearchManagerType {

  func getState() -> SearchCardState {
    let document = Managers.documents.read(.searchCardState)
    return document as? SearchCardState ?? SearchCardState(page: .tram, selectedLines: [])
  }

  func save(_ state: SearchCardState) {
    let document = DocumentData.searchCardState(value: state)
    Managers.documents.write(document)
  }
}
