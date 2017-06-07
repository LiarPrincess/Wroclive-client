//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class LineSelectionSectionHeaderView: UICollectionReusableView {

  //MARK: - Properties

  var subtypeName = UILabel()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Methods

  func setUp(with viewModel: LineSelectionSectionViewModel) {
    self.subtypeName.text = viewModel.subtypeName
  }

}

//MARK: - UI Init

extension LineSelectionSectionHeaderView {

  fileprivate func initLayout() {
    self.subtypeName.numberOfLines = 0
    self.subtypeName.font          = Theme.current.font.headline
    self.subtypeName.textAlignment = .center
    self.addSubview(self.subtypeName)

    self.subtypeName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
