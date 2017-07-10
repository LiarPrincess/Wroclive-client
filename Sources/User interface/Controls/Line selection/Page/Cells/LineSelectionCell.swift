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

  // MARK: - Methods

  func setUp(with viewModel: LineSelectionCellViewModel) {
    self.lineName.text = viewModel.lineName
  }

  fileprivate func updateTextColorForSelectionStatus() {
    if self.isSelected {
      self.lineName.textColor = Theme.current.colorScheme.background
    }
    else {
      self.lineName.textColor = Theme.current.colorScheme.text
    }
  }

}

// MARK: - UI Init

extension LineSelectionCell {

  fileprivate func initLayout() {
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor    = Theme.current.colorScheme.primary
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.lineName.setStyle(.body)
    self.lineName.numberOfLines = 1
    self.lineName.textAlignment = .center
    self.lineName.isUserInteractionEnabled = false

    self.contentView.addSubview(self.lineName)

    self.lineName.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
