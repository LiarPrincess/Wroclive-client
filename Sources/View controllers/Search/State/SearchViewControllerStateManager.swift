//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchViewControllerStateManager: SearchViewControllerStateManagerProtocol {

  // MARK: - Singleton

  static let instance: SearchViewControllerStateManagerProtocol = SearchViewControllerStateManager()

  // MARK: - Properties

  var state = SearchViewControllerStateManager.testData()

  // MARK: - Init

  private init() { }

  // MARK: - StorageManagerProtocol

  func saveState(state: SearchViewControllerState) {
    self.state = state
  }

  func getState() -> SearchViewControllerState {
    return self.state
  }

  // MARK: - Methods

  private static func testData() -> SearchViewControllerState {
    let selectedLines = [
      Line(name: "325", type: .bus, subtype: .regular),
      Line(name: "4", type: .tram, subtype: .regular),
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "D", type: .bus, subtype: .express),
      Line(name: "11", type: .tram, subtype: .regular),
      Line(name: "14", type: .tram, subtype: .regular),
      Line(name: "20", type: .tram, subtype: .regular),
      Line(name: "24", type: .tram, subtype: .regular),
      Line(name: "107", type: .bus, subtype: .regular),
      Line(name: "125", type: .bus, subtype: .regular),
      Line(name: "126", type: .bus, subtype: .regular),
      Line(name: "127", type: .bus, subtype: .regular),
      Line(name: "251", type: .bus, subtype: .night)
    ]
    return SearchViewControllerState(filter: .tram, selectedLines: selectedLines)
  }
}
