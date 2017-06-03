//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

extension BookmarkCell {

  func initLayout() {
    let tintColor = UIApplication.shared.keyWindow!.tintColor

    self.initLabel(self.bookmarkName)
    self.bookmarkName.font = FontManager.instance.bookmarkCellTitle
    self.addSubview(self.bookmarkName)

    self.bookmarkName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.initLabel(self.tramLines)
    self.tramLines.textColor = tintColor
    self.tramLines.font      = FontManager.instance.bookmarkCellContent
    self.addSubview(self.tramLines)

    self.tramLines.snp.makeConstraints { make in
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(Layout.LinesLabel.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
    }

    self.initLabel(self.busLines)
    self.busLines.textColor  = tintColor
    self.busLines.font       = FontManager.instance.bookmarkCellContent
    self.addSubview(self.busLines)

    self.busLines.snp.makeConstraints { make in
      make.top.equalTo(self.tramLines.snp.bottom).offset(Layout.LinesLabel.topOffset)
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.bottom.equalToSuperview().offset(-Layout.bottomOffset)
    }
  }

  fileprivate func initLabel(_ label: UILabel) {
    label.numberOfLines = 0
    label.textAlignment = .center
  }
  
}
