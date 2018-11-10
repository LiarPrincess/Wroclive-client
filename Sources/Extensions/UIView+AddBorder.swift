// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UIView {
  func addBottomBorder() {
    let view = UIView()
    view.backgroundColor = Theme.colors.accentLight

    self.addSubview(view, constraints: [
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.heightAnchor, equalToConstant: CGFloat(1.0) / AppEnvironment.device.screenScale),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor)
    ])
  }
}
