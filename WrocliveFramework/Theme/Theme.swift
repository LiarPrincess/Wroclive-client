// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import Foundation
import MapKit

// Source:
// https://medium.com/@abhimuralidharan/maintaining-a-colour-theme-manager-on-ios-swift-178b8a6a92
public enum Theme {

  public fileprivate(set) static var textFont: FontPreset = SystemFont()
  public fileprivate(set) static var iconFont: FontPreset = FontAwesome()
}
