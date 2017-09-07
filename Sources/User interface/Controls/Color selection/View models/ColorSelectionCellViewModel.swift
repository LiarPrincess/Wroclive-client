//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionCellViewModel {
  var color: UIColor { get }
}

struct AnyColorSelectionCellViewModel: ColorSelectionCellViewModel {
  private let viewModel: ColorSelectionCellViewModel

  var color: UIColor { return self.viewModel.color }

  init(_ viewModel: ColorSelectionCellViewModel) {
    self.viewModel = viewModel
  }
}

extension TintColor: ColorSelectionCellViewModel {
  var color: UIColor { return self.value }
}

extension VehicleColor: ColorSelectionCellViewModel {
  var color: UIColor { return self.value }
}
