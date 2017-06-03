//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

//struct LineSelectionState {
//  let lineType: LineType
//  let lines: [Line]
//}

protocol LinesManagerProtocol {
  func getLines() -> [Line]

  //func saveLineSelectionState(state: X)
  //func getLineSelectionState()
}
