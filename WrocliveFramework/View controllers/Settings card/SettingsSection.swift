// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Settings.Table

public enum SettingsSection {
  case mapType
  case general([GeneralCell])
  case programming([ProgrammingCell])

  public var text: String {
    switch self {
    case .mapType:
      return Localization.MapType.header
    case .general:
      return Localization.General.header
    case .programming:
      return Localization.Programming.header
    }
  }

  public enum GeneralCell {
    case share
    case rate
    case privacyPolicy

    public var text: String {
      switch self {
      case .share: return Localization.General.share
      case .rate: return Localization.General.rate
      case .privacyPolicy: return Localization.General.privacyPolicy
      }
    }

    public var image: ImageAsset {
      switch self {
      case .share: return ImageAsset.settingsShare
      case .rate: return ImageAsset.settingsRate
      case .privacyPolicy: return ImageAsset.settingsPrivacyPolicy
      }
    }
  }

  public enum ProgrammingCell {
    case reportError
    case showCode

    public var text: String {
      switch self {
      case .reportError: return Localization.Programming.reportError
      case .showCode: return Localization.Programming.showCode
      }
    }

    public var image: ImageAsset {
      switch self {
      case .reportError: return ImageAsset.settingsReportError
      case .showCode: return ImageAsset.settingsShowCode
      }
    }
  }
}
