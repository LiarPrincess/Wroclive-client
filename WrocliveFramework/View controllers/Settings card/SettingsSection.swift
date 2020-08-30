// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Settings.Table

public enum SettingsSection {
  case mapType
  case general([GeneralCell])

  public var text: String {
    switch self {
    case .mapType:
      return Localization.MapType.header
    case .general:
      return Localization.General.header
    }
  }

  public enum GeneralCell {
    case share
    case rate
    case about

    public var text: String {
      switch self {
      case .about: return Localization.General.about
      case .share: return Localization.General.share
      case .rate: return Localization.General.rate
      }
    }

    public var image: ImageAsset {
      switch self {
      case .about: return ImageAsset.settingsAbout
      case .share: return ImageAsset.settingsShare
      case .rate: return ImageAsset.settingsRate
      }
    }
  }
}
