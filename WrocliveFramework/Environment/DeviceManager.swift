// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol DeviceManagerType {

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
public final class DeviceManager: DeviceManagerType {

  private var device: UIDevice { return UIDevice.current }
  private var screen: UIScreen { return UIScreen.main }

  public init() { }

  // MARK: - Device

  public var model:         String { return self.device.model }
  public var systemName:    String { return self.device.systemName }
  public var systemVersion: String { return self.device.systemVersion }

  // MARK: - Screen

  public var screenScale:  CGFloat { return screen.scale }
  public var screenBounds: CGRect  { return screen.bounds }

  public var preferredFontSize: CGFloat  {
    return UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
  }
}
