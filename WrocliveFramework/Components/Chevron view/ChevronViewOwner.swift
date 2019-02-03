// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol ChevronViewOwner {
  var chevronView: ChevronView { get }
}

extension ChevronViewOwner where Self: UIViewController {

  func addChevronView(in container: UIView) {
    self.chevronView.setState(.down)
    self.chevronView.color = Theme.colors.accentLight

    container.addSubview(self.chevronView, constraints: [
      make(\UIView.topAnchor,     equalToSuperview: \UIView.topAnchor, constant: 8.0),
      make(\UIView.centerXAnchor, equalToSuperview: \UIView.centerXAnchor),
      make(\UIView.widthAnchor,   equalToConstant:  ChevronView.nominalSize.width),
      make(\UIView.heightAnchor,  equalToConstant:  ChevronView.nominalSize.height)
    ])
  }

  func updateChevronViewDuringInteractiveDismissal(percent: CGFloat) {
    // we assume that before we start chevron is in '.down' position
    self.chevronView.angle = -ChevronView.maxAngle * (1.0 - percent)
  }

  func updateChevronViewAfterInteractiveDismissal() {
    self.chevronView.setState(.down)
  }
}
