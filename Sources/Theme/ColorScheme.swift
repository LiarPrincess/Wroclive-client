// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

struct ColorScheme {

  let tint = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.95, alpha: 1.0)
  let tram = UIColor(hue: 0.60, saturation: 0.65, brightness: 0.80, alpha: 1.0)
  let bus  = UIColor(hue: 0.00, saturation: 0.85, brightness: 0.80, alpha: 1.0)

  let background  = UIColor.white
  let accentLight = UIColor(white: 0.8, alpha: 1.0)
  let accentDark  = UIColor(white: 0.3, alpha: 1.0)
  let text        = UIColor.black

  let barStyle  = UIBarStyle.default
  let blurStyle = UIBlurEffectStyle.extraLight
}
