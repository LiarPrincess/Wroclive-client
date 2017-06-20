//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Constants = LineSelectionControlConstants
fileprivate typealias Layout    = Constants.Layout.SectionHeader

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
    self.sectionName.isUserInteractionEnabled = false
    
    self.addSubview(self.sectionName)

    self.sectionName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topPadding)
      make.left.right.equalToSuperview()
    }
  }
  
}
