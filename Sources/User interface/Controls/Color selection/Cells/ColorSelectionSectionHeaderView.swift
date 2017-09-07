//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout.SectionHeader

class ColorSelectionSectionHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let sectionName = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.sectionName.numberOfLines = 0
    self.sectionName.isUserInteractionEnabled = false

    self.addSubview(self.sectionName)
    self.sectionName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.right.equalToSuperview()
    }
  }

  // MARK: - Methods

  func setUp<TViewModel: ColorSelectionSectionViewModel>(with viewModel: TViewModel) {
    let textAttributes = Managers.theme.textAttributes(for: .subheadline)
    self.sectionName.attributedText = NSAttributedString(string: viewModel.name, attributes: textAttributes)
  }
}
