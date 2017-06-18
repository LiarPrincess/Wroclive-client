//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

class LineSelectionSectionHeaderView: UICollectionReusableView {

  //MARK: - Properties

  var sectionName = UILabel()

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
    self.sectionName.text = viewModel.sectionName
  }

}

//MARK: - UI Init

extension LineSelectionSectionHeaderView {

  fileprivate func initLayout() {
    self.sectionName.setStyle(.subheadline)
    self.sectionName.numberOfLines = 0
    self.sectionName.textAlignment = .center
    self.addSubview(self.sectionName)

    self.sectionName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
