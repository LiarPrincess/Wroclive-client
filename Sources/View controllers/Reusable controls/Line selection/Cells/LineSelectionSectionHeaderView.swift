//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class LineSelectionSectionHeaderView: UICollectionReusableView {

  //MARK: - Properties

  var sectionTitle = UILabel()

  //MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Methods

  func setUp(with viewModel: LineSelectionSectionHeaderViewModel) {
    self.sectionTitle.text = viewModel.sectionTitle
  }

}

//MARK: - UI Init

extension LineSelectionSectionHeaderView {

  fileprivate func initLayout() {
    self.sectionTitle.numberOfLines = 0
    self.sectionTitle.font          = FontManager.instance.lineSelectionSectionHeader
    self.sectionTitle.textAlignment = .center
    self.addSubview(self.sectionTitle)

    self.sectionTitle.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
