//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout

class ColorSelectionSectionHeaderView: UICollectionReusableView {

  // MARK: - Properties

  private let sectionName = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = Managers.theme.colors.configurationBackground
    self.addBorder(at: .bottom)

    self.sectionName.numberOfLines = 0
    self.sectionName.isUserInteractionEnabled = false

    self.addSubview(self.sectionName)
    self.sectionName.snp.makeConstraints { make in
      make.left.equalToSuperview().offset(Layout.leftOffset)
      make.right.equalToSuperview().offset(-Layout.rightOffset)
      make.bottom.equalToSuperview().offset(-Layout.Section.Header.bottomInset)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func setUp<TViewModel: ColorSelectionSectionViewModel>(with viewModel: TViewModel) {
    var textAttributes = Managers.theme.textAttributes(for: .caption)
    textAttributes[NSForegroundColorAttributeName] = UIColor(white: 0.4, alpha: 1.0)
    self.sectionName.attributedText = NSAttributedString(string: viewModel.name, attributes: textAttributes)
  }
}
