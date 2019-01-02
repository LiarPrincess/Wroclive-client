// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Settings.Table

enum SettingsSectionType {
  case general

  var text: String {
    switch self {
    case .general: return Localization.General.header
    }
  }
}
