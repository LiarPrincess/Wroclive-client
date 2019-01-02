// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol DeviceManagerType {

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

// sourcery: manager
class DeviceManager: DeviceManagerType {

  private var device: UIDevice { return UIDevice.current }
  private var screen: UIScreen { return UIScreen.main }

  // MARK: - Device

  var model:         String { return self.device.model }
  var systemName:    String { return self.device.systemName }
  var systemVersion: String { return self.device.systemVersion }

  // MARK: - Screen

  var screenScale:  CGFloat { return screen.scale }
  var screenBounds: CGRect  { return screen.bounds }

  var preferredFontSize: CGFloat  {
    return UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
  }
}
