//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

private typealias Localization = Localizable.Settings.Table

enum SettingsSectionType {
  case mapType
  case general

  var text: String {
    switch self {
    case .mapType: return Localization.MapType.header
    case .general: return Localization.General.header
    }
  }
}
