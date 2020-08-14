// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Localization = Localizable.Settings.Table

public struct SettingsSection {

  public enum Kind {
    case general

    public var text: String {
      switch self {
      case .general: return Localization.General.header
      }
    }
  }

  public enum CellKind {
    case share
    case rate
    case about

    public var text: String {
      switch self {
      case .about: return Localization.General.about
      case .share: return Localization.General.share
      case .rate:  return Localization.General.rate
      }
    }
  }

  public let kind: Kind
  public let cells: [CellKind]

  public init(kind: Kind, cells: [CellKind]) {
    self.kind = kind
    self.cells = cells
  }
}
