//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum ColorSelectionSectionType {
  case tint
  case tram
  case bus
}

struct ColorSelectionSection: ColorSelectionSectionViewModel {
  let type:   ColorSelectionSectionType
  let name:   String
  let colors: [AnyColorSelectionSectionColor]

  init(for type: ColorSelectionSectionType) {
    self.type   = type
    self.name   = ColorSelectionSection.createName(for: type)
    self.colors = ColorSelectionSection.createColors(for: type)
  }

  private static func createName(for type: ColorSelectionSectionType) -> String {
    switch type {
    case .tint: return "Tint"
    case .tram: return "Tram"
    case .bus:  return "Bus"
    }
  }

  private static func createColors(for type: ColorSelectionSectionType) -> [AnyColorSelectionSectionColor] {
    let tintColors:    [TintColor]    = [.red, .blue, .green, .orange, .pink, .black]
    let vehicleColors: [VehicleColor] = [.red, .blue, .green, .pink, .black]

    switch type {
    case .tint: return tintColors.map    { AnyColorSelectionSectionColor($0) }
    case .tram: return vehicleColors.map { AnyColorSelectionSectionColor($0) }
    case .bus:  return vehicleColors.map { AnyColorSelectionSectionColor($0) }
    }
  }
}
