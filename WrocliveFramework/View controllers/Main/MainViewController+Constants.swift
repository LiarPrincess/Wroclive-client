// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension MainViewController {
  public enum Constants {
    /// This size is responsible for 'tappable' area
    public static let toolbarButtonSize = CGSize(width: 52.0, height: 52.0)
    /// This size is responsible for image (duh...)
    ///
    /// button size (44.0) - 2 * inset (8.0) = 44.0 - 16.0 = 28.0
    public static let toolbarButtonImageSize = CGSize(width: 28.0, height: 28.0)
  }
}
