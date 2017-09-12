//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionCellViewModel {
  var color: UIColor { get }
}

struct AnyColorSelectionCellViewModel: ColorSelectionCellViewModel {
  let innerViewModel: ColorSelectionCellViewModel

  var color: UIColor { return self.innerViewModel.color }

  init(_ innerViewModel: ColorSelectionCellViewModel) {
    self.innerViewModel = innerViewModel
  }
}

extension TintColor: ColorSelectionCellViewModel {
  var color: UIColor { return self.value }
}

extension VehicleColor: ColorSelectionCellViewModel {
  var color: UIColor { return self.value }
}
