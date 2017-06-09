//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

enum BorderEdge {
  case top
  case bottom
}

extension UIView {

  func addBorder(at borderType: BorderEdge) {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
    self.addSubview(view)

    view.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.height.equalTo(CGFloat(1) / UIScreen.main.scale)

      if borderType == .top {
        make.top.equalToSuperview()
      }
      else {
        make.bottom.equalToSuperview()
      }
    }
  }

}
