//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Configuration.Theme

enum ColorSelectionSectionType {
  case tint
  case tram
  case bus
}

struct ColorSelectionSection: ColorSelectionSectionViewModel {

  // MARK: - Properties

  let type:  ColorSelectionSectionType
  let name:  String
  let cells: [AnyColorSelectionCellViewModel]

  // MARK: - Init

  init(for type: ColorSelectionSectionType) {
    self.type  = type
    self.name  = ColorSelectionSection.createName(for: type)
    self.cells = ColorSelectionSection.createColors(for: type)
  }

  private static func createName(for type: ColorSelectionSectionType) -> String {
    switch type {
    case .tint: return Localization.tint.uppercased()
    case .tram: return Localization.tram.uppercased()
    case .bus:  return Localization.bus.uppercased()
    }
  }

  private static func createColors(for type: ColorSelectionSectionType) -> [AnyColorSelectionCellViewModel] {
    switch type {
    case .tint:
      let colors: [TintColor] = [.red, .blue, .green, .orange, .pink, .black]
      return colors.map { AnyColorSelectionCellViewModel($0) }
    case .tram, .bus:
      let colors: [VehicleColor] = [.red, .blue, .green, .orange, .pink, .black]
      return colors.map { AnyColorSelectionCellViewModel($0) }
    }
  }
}
