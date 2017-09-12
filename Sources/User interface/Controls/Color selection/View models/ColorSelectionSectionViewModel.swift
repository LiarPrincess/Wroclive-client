//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionSectionViewModel {
  var name:       String { get }
  var cells:      [AnyColorSelectionCellViewModel] { get }
  var cellsCount: Int { get }
}

extension ColorSelectionSectionViewModel {
  var cellsCount: Int { return self.cells.count }
}
