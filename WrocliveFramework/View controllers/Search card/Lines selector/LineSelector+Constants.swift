// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// swiftlint:disable nesting

extension LineSelector {

  internal enum Constants {

    internal enum Cell {
      internal static let margin = CGFloat(2.0)
      internal static let minSize = CGFloat(50.0)

      internal static let cornerRadius = CGFloat(8.0)

      // We need to use bold, otherwise text would look too thin on bright background
      internal static let selectedTextAttributes = TextAttributes(style: .bodyBold,
                                                                  color: .background,
                                                                  alignment: .center)

      internal static let notSelectedTextAttributes = TextAttributes(style: .body,
                                                                     color: .text,
                                                                     alignment: .center)
    }

    internal enum Header {
      internal static let topInset = CGFloat(16.0)
      internal static let bottomInset = CGFloat(8.0)

      internal static let textAttributes = TextAttributes(style: .headline,
                                                          alignment: .center)
    }
  }
}
