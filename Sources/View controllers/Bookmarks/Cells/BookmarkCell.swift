//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

class BookmarkCell: UITableViewCell {

  //MARK: - Properties

  let bookmarkName = UILabel()
  let tramLines    = UILabel()
  let busLines     = UILabel()

  //MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Overriden

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.bookmarkName.text  = viewModel.bookmarkName

    let hasTramLines        = !viewModel.tramLines.isEmpty
    self.tramLines.text     = viewModel.tramLines
    self.tramLines.isHidden = !hasTramLines

    self.tramLines.snp.updateConstraints { make in
      let topOffset = hasTramLines ? Layout.LinesLabel.topOffset : 0.0
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(topOffset)
    }

    let hasBusLines         = !viewModel.busLines.isEmpty
    self.busLines.text      = viewModel.busLines
    self.busLines.isHidden  = !hasBusLines

    self.busLines.snp.updateConstraints { make in
      let topOffset = hasBusLines ? Layout.LinesLabel.topOffset : 0.0
      make.top.equalTo(self.tramLines.snp.bottom).offset(topOffset)
    }
  }

}
