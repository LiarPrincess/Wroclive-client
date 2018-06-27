// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol DeviceManagerType: ManagerType {

  // MARK: - Device

  /// iPhone, iPod touch
  var model: String { get }

  /// iOS, watchOS, tvOS
  var systemName: String { get }

  /// 10.2
  var systemVersion: String { get }

  // MARK: - Screen

  /// Point to pixel ratio
  var screenScale:  CGFloat { get }

  /// Screen resolution
  var screenBounds: CGRect  { get }

  /// May vary depending on user settings.
  /// By default 17pt for UIContentSizeCategoryLarge
  var preferredFontSize: CGFloat { get }
}
