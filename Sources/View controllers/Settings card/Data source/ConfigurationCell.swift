//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Localization = Localizable.Configuration.Cell

enum ConfigurationCell: ConfigurationCellViewModel {
  case personalization
  case contact
  case share
  case rate

  var text: String {
    switch self {
    case .personalization: return Localization.colors
    case .contact:         return Localization.contact
    case .share:           return Localization.share
    case .rate:            return Localization.rate
    }
  }

  var isEnabled: Bool {
    switch self {
    case .personalization: return true
    default:               return true
    }
  }

  var accessibilityIdentifier: String {
    let base = "ConfigurationCellView."
    switch self {
    case .personalization: return base + "colors"
    case .contact:         return base + "contact"
    case .share:           return base + "share"
    case .rate:            return base + "rate"
    }
  }
}
