//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

enum SettingsCellType {
  case mapType
  case share
  case rate
  case about
}

typealias SettingsSection = RxSectionModel<String, SettingsCellType>
