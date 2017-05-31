//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - LineSelectionSectionHeaderViewModel

struct LineSelectionSectionHeaderViewModel {
  let sectionTitle: String

  init(for type: LineType, _ subtype: LineSubtype) {
    self.sectionTitle = String(describing: subtype).capitalized
  }
}

//MARK: - LineSelectionSectionHeaderView

class LineSelectionSectionHeaderView: UICollectionReusableView {

  //MARK: - Properties

  fileprivate var sectionTitle = UILabel()

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
    self.sectionTitle.numberOfLines = 1
    self.sectionTitle.font = FontManager.instance.lineSelectionSectionHeader
    self.sectionTitle.textAlignment = .center
    self.addSubview(self.sectionTitle)

    self.sectionTitle.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
