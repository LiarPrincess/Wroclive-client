//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct SearchViewControllerState {
  let selectedLines:    [Line]

  init(selectedLines: [Line]) {
    self.selectedLines = selectedLines
  }
}
