//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import UIKit

fileprivate typealias Constants = LineSelectionViewControllerConstants

//MARK: - LineSelectionCellViewModel

struct LineSelectionCellHeaderViewModel {
  let sectionTitle: String

  init(from section: LineSelectionSection) {
    self.sectionTitle = String(describing: section.lineSubtype).capitalized
  }
}

//MARK: - LineSelectionCellHeader

class LineSelectionCellHeader: UICollectionReusableView {

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

  func setUp(with viewModel: LineSelectionCellHeaderViewModel) {
    self.sectionTitle.text = viewModel.sectionTitle
  }

}

//MARK: - UI Init

extension LineSelectionCellHeader {

  fileprivate func initLayout() {
    self.sectionTitle.numberOfLines = 1
    self.sectionTitle.font = FontManager.instance.lineSelectionCellHeader
    self.sectionTitle.textAlignment = .center
    self.addSubview(self.sectionTitle)

    self.sectionTitle.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
