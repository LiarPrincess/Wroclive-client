//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

enum BorderEdge {
  case top
  case bottom
}

extension UIView {
  func addBorder(at borderEdge: BorderEdge) {
    let view = UIView()
    view.backgroundColor = Managers.theme.colors.accentLight
    self.addSubview(view)

    view.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.height.equalTo(CGFloat(1.0) / Managers.device.screenScale)

      switch borderEdge {
      case .top:
        make.top.equalToSuperview()
      case .bottom:
        make.bottom.equalToSuperview()
      }
    }
  }
}
