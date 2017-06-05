//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

class BookmarkCellLine: UICollectionViewCell {

  //MARK: - Properties

  var lineName = UILabel()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Methods

  func setUp(with viewModel: BookmarkCellLineViewModel) {
    self.lineName.text = viewModel.lineName
  }

}

//MARK: - UI Init

extension BookmarkCellLine {

  fileprivate func initLayout() {
    self.tintColor = UIApplication.shared.keyWindow!.tintColor

    self.lineName.numberOfLines = 1
    self.lineName.font          = FontManager.instance.bookmarkCellContent
    self.lineName.textAlignment = .center
    self.lineName.textColor     = self.tintColor
    self.addSubview(self.lineName)

    self.lineName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
