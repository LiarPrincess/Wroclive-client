//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = ColorSelectionViewControllerConstants.Layout.Cell

class ColorSelectionCell: UICollectionViewCell {

  // MARK: - Properties

  private let label = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.clipsToBounds      = true
    self.layer.cornerRadius = Layout.cornerRadius

    self.label.numberOfLines = 1
    self.label.isUserInteractionEnabled = false

    self.contentView.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Overriden

  override var isSelected: Bool {
    didSet {
      if oldValue != self.isSelected { // performance
        self.updateSelectionText()
      }
    }
  }

  private func updateSelectionText() {
    if self.isSelected {
      let textAttributes = Managers.theme.textAttributes(for: .body, fontType: .icon, alignment: .center, color: .background)
      self.label.attributedText = NSAttributedString(string: "\u{f00c}", attributes: textAttributes)
    }
    else { self.label.attributedText = nil }
  }

  // MARK: - Methods

  func setUp<ViewModel: ColorSelectionCellViewModel>(with viewModel: ViewModel) {
    self.backgroundColor = viewModel.color
  }
}
