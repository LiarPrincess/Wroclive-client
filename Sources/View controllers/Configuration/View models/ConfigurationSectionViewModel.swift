//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ConfigurationSectionViewModel {
  associatedtype CellViewModel: ConfigurationCellViewModel

  var cells:      [CellViewModel] { get }
  var cellsCount: Int { get }
}

extension ConfigurationSectionViewModel {
  var cellsCount: Int { return self.cells.count }
}
