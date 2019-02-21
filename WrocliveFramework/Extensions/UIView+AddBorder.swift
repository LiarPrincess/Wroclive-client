// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

extension UIView {

  private var width: CGFloat { return CGFloat(1.0) / AppEnvironment.device.screenScale }
  private var color: UIColor { return Theme.colors.accentLight }

  public func addTopBorder() {
    let view = UIView()
    view.backgroundColor = color

    self.addSubview(view, constraints: [
      make(\UIView.topAnchor,    equalToSuperview: \UIView.topAnchor),
      make(\UIView.heightAnchor, equalToConstant:  width),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor)
    ])
  }

  public func addBottomBorder() {
    let view = UIView()
    view.backgroundColor = color

    self.addSubview(view, constraints: [
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor),
      make(\UIView.heightAnchor, equalToConstant:  width),
      make(\UIView.leftAnchor,   equalToSuperview: \UIView.leftAnchor),
      make(\UIView.rightAnchor,  equalToSuperview: \UIView.rightAnchor)
    ])
  }
}
