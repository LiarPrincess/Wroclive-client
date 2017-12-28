//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

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

  // 17pt for UIContentSizeCategoryLarge
  var preferredFontSize: CGFloat { get }
}
