// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

enum BorderEdge {
  case top
  case bottom
}

extension UIView {
  func addBorder(at borderEdge: BorderEdge) {
    let view = UIView()
    view.backgroundColor = AppEnvironment.current.theme.colors.accentLight
    self.addSubview(view)

    view.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.height.equalTo(CGFloat(1.0) / AppEnvironment.current.device.screenScale)

      switch borderEdge {
      case .top:
        make.top.equalToSuperview()
      case .bottom:
        make.bottom.equalToSuperview()
      }
    }
  }
}
