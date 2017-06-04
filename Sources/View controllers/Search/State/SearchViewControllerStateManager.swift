//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class SearchViewControllerStateManager: SearchViewControllerStateManagerProtocol {

  //MARK: - Singleton

  static let instance: SearchViewControllerStateManagerProtocol = SearchViewControllerStateManager()

  //MARK: - Properties

  var state = SearchViewControllerStateManager.testData()

  //MARK: - Init

  private init() { }

  //MARK: - StorageManagerProtocol

  func saveState(state: SearchViewControllerState) {
    self.state = state
  }

  func getState() -> SearchViewControllerState {
    return self.state
  }

  //MARK: - Methods

  private static func testData() -> SearchViewControllerState {
    let selectedLines = [
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "D", type: .bus, subtype: .express),
      Line(name: "K", type: .bus, subtype: .express)
    ]
    return SearchViewControllerState(selectedLines: selectedLines)
  }
}
