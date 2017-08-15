//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

fileprivate typealias Layout = LineSelectionViewControllerConstants.Layout.Cell

class LineSelectionCell: UICollectionViewCell {

  // MARK: - Properties

  fileprivate var lineNameLabel = UILabel()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
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
    self.setLineLabel(viewModel.lineName)
  }

  private func updateTextColorForSelectionStatus() {
    let text = self.lineNameLabel.attributedText?.string ?? self.lineNameLabel.text ?? ""
    self.setLineLabel(text)
  }

  private func setLineLabel(_ value: String) {
    let color: Theme.Color = self.isSelected ? .background : .text
    let textAttributes = Theme.current.textAttributes(for: .body, color: color)
    self.lineNameLabel.attributedText = NSAttributedString(string: value, attributes: textAttributes)
  }
}

// MARK: - UI Init

extension LineSelectionCell {

  fileprivate func initLayout() {
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor    = Theme.current.colorScheme.tint
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.lineNameLabel.numberOfLines = 1
    self.lineNameLabel.textAlignment = .center
    self.lineNameLabel.isUserInteractionEnabled = false

    self.contentView.addSubview(self.lineNameLabel)

    self.lineNameLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
