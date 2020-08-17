// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

extension TextAttributes {

  public enum Style {
    case largeTitle
    case headline
    case body
    case bodyBold
    case footnote
  }

  public enum FontType {
    case text
    case icon
  }

  public enum Color {
    case background
    case text
    case tint
    case bus
    case tram
    case white
  }

  public enum Alignment {
    case left
    case right
    case center
    case natural
  }
}