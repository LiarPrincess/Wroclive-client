//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

private typealias Localization = Localizable.Settings.Table

enum SettingsSectionType {
  case general

  var text: String {
    switch self {
    case .general: return Localization.General.header
    }
  }
}
