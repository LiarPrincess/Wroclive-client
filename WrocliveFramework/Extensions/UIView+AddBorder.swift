// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

public extension UIView {

  private var width: CGFloat { return CGFloat(1.0) / AppEnvironment.device.screenScale }
  private var color: UIColor { return Theme.colors.accentLight }

  func addTopBorder() {
    let view = UIView()
    view.backgroundColor = color

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(width)
      make.top.left.right.equalToSuperview()
    }
  }

  func addBottomBorder() {
    let view = UIView()
    view.backgroundColor = color

    self.addSubview(view)
    view.snp.makeConstraints { make in
      make.height.equalTo(width)
      make.bottom.left.right.equalToSuperview()
    }
  }
}
