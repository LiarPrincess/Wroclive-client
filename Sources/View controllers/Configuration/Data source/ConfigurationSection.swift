//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum ConfigurationSectionType {
  case personalization
  case about
}

struct ConfigurationSection: ConfigurationSectionViewModel {
  let type:  ConfigurationSectionType
  let cells: [ConfigurationCell]

  init(for type: ConfigurationSectionType) {
    self.type  = type
    self.cells = ConfigurationSection.createCells(for: type)
  }

  private static func createCells(for type: ConfigurationSectionType) -> [ConfigurationCell] {
    switch type {
    case .personalization: return [.personalization]
    case .about:           return [.share, .tutorial, .contact, .rate]
    }
  }
}
