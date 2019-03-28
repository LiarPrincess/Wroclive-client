// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

protocol ChevronViewOwner {
  var chevronView: ChevronView { get }
}

extension ChevronViewOwner where Self: UIViewController {

  func addChevronView(in container: UIView) {
    self.chevronView.setState(.down)
    self.chevronView.color = Theme.colors.accentLight

    container.addSubview(self.chevronView)
    self.chevronView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8.0)
      make.centerX.equalToSuperview()
      make.width.equalTo(ChevronView.nominalSize.width)
      make.height.equalTo(ChevronView.nominalSize.height)
    }
  }

  func updateChevronViewDuringInteractiveDismissal(percent: CGFloat) {
    // we assume that before we start chevron is in '.down' position
    let makeChevronFlatAt = CGFloat(0.75)
    let chevronPercent = CGFloat.minimum(percent, makeChevronFlatAt)
    self.chevronView.angle = -ChevronView.maxAngle * (makeChevronFlatAt - chevronPercent)
  }

  func updateChevronViewAfterInteractiveDismissal() {
    self.chevronView.setState(.down)
  }
}
