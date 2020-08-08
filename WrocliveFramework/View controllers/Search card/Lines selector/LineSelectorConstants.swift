// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum LineSelectorConstants {

  internal enum Cell {
    internal enum Layout {
      internal static let margin = CGFloat(2.0)
      internal static let minSize = CGFloat(50.0)

      internal static let cornerRadius = CGFloat(8.0)
    }

    internal enum TextStyles {
      internal static var selected: TextAttributes {
        // We need to use bold, otherwise text would look too thin on bright background
        return TextAttributes(style: .bodyBold,
                              color: .background,
                              alignment: .center)
      }

      internal static var notSelected: TextAttributes {
        return TextAttributes(style: .body,
                              color: .text,
                              alignment: .center)
      }
    }
  }

  internal enum Header {
    internal enum Layout {
      internal static let topInset = CGFloat(16.0)
      internal static let bottomInset = CGFloat(8.0)
    }

    internal enum TextStyles {
      internal static var header: TextAttributes {
        return TextAttributes(style: .headline, alignment: .center)
      }
    }
  }
}
