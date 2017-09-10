//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionSectionColor {
  var color: UIColor { get }
}

struct AnyColorSelectionSectionColor: ColorSelectionSectionColor {
  private let viewModel: ColorSelectionSectionColor

  var color: UIColor { return self.viewModel.color }

  init(_ viewModel: ColorSelectionSectionColor) {
    self.viewModel = viewModel
  }
}

extension TintColor: ColorSelectionSectionColor {
  var color: UIColor { return self.value }
}

extension VehicleColor: ColorSelectionSectionColor {
  var color: UIColor { return self.value }
}
