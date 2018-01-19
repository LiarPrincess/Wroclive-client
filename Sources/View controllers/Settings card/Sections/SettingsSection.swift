//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

private typealias Localization = Localizable.Settings.Table

enum SettingsCellType {
  case mapType
  case share
  case rate
  case about

  var text: String {
    switch self {
    case .mapType: return String.empty
    case .about:   return Localization.General.about
    case .share:   return Localization.General.share
    case .rate:    return Localization.General.rate
    }
  }
}

typealias SettingsSection = RxSectionModel<String, SettingsCellType>
