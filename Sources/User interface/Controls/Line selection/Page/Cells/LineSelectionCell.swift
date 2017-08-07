//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = LineSelectionViewControllerConstants.Layout.Cell

class LineSelectionCell: UICollectionViewCell {

  // MARK: - Properties

  var lineName = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
    self.updateTextColorForSelectionStatus()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override var isSelected: Bool {
    didSet {
      if oldValue != self.isSelected { // performance
        self.updateTextColorForSelectionStatus()
      }
    }
  }

  // MARK: - Private - Methods

  func setUp(with viewModel: LineSelectionCellViewModel) {
    self.lineName.text = viewModel.lineName
  }

  fileprivate func updateTextColorForSelectionStatus() {
    let textColor: Color = self.isSelected ? .background : .text
    self.lineName.setStyle(.body, color: textColor)
  }

}

// MARK: - UI Init

extension LineSelectionCell {

  fileprivate func initLayout() {
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor    = Theme.current.colorScheme.tint
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.lineName.setStyle(.body, color: .text)
    self.lineName.numberOfLines = 1
    self.lineName.textAlignment = .center
    self.lineName.isUserInteractionEnabled = false

    self.contentView.addSubview(self.lineName)

    self.lineName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
