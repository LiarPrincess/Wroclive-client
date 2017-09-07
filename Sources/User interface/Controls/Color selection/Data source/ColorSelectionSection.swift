//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum ColorSelectionSection: Int, ColorSelectionSectionViewModel, EnumCollection {
  case tint
  case tram
  case bus

  var name: String {
    switch self {
    case .tint: return "Tint color"
    case .tram: return "Tram color"
    case .bus:  return "Bus color"
    }
  }

  var cellViewModels: [AnyColorSelectionCellViewModel] {
    switch self {
    case .tint: return TintColor.allValues.map { AnyColorSelectionCellViewModel($0) }
    case .tram: return VehicleColor.allValues.map { AnyColorSelectionCellViewModel($0) }
    case .bus:  return VehicleColor.allValues.map { AnyColorSelectionCellViewModel($0) }
    }
  }

  static var count: Int { return self.allValues.count }
}
