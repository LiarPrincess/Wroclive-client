//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Constants = LineSelectionViewControllerConstants
private typealias Layout    = Constants.Layout.SectionHeader

class LineSelectionSectionHeaderView: UICollectionReusableView {

  // MARK: - Properties

  var sectionName = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func setUp(with viewModel: LineSelectionSectionViewModel) {
    let textAttributes = Managers.theme.textAttributes(for: .subheadline, alignment: .center)
    self.sectionName.attributedText = NSAttributedString(string: viewModel.sectionName, attributes: textAttributes)
  }

}

// MARK: - UI Init

extension LineSelectionSectionHeaderView {

  fileprivate func initLayout() {
    self.sectionName.numberOfLines = 0
    self.sectionName.isUserInteractionEnabled = false

    self.addSubview(self.sectionName)

    self.sectionName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.right.equalToSuperview()
    }
  }

}
