//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = LineSelectionViewControllerConstants.Layout.Cell

class LineSelectionCell: UICollectionViewCell {

  // MARK: - Properties

  private let lineNameLabel = UILabel()
  private var theme: ThemeManager? = nil

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.lineNameLabel.numberOfLines = 1
    self.lineNameLabel.isUserInteractionEnabled = false

    self.contentView.addSubview(self.lineNameLabel)
    self.lineNameLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Overriden

  override var isSelected: Bool {
    didSet {
      if oldValue != self.isSelected { // performance
        self.updateTextColorForSelectionStatus()
      }
    }
  }

  private func updateTextColorForSelectionStatus() {
    let text = self.lineNameLabel.attributedText?.string ?? self.lineNameLabel.text ?? ""
    self.setLineLabel(text)
  }

  // MARK: - Methods

  func setUp(with viewModel: LineSelectionCellViewModel) {
    self.theme = viewModel.theme
    self.selectedBackgroundView?.backgroundColor = viewModel.theme.colorScheme.tintColor.value
    self.setLineLabel(viewModel.lineName)
  }

  private func setLineLabel(_ value: String) {
    guard let theme = self.theme else { return }

    let textColor: TextColor = self.isSelected ? .background : .text
    let textAttributes = theme.textAttributes(for: .body, alignment: .center, color: textColor)
    self.lineNameLabel.attributedText = NSAttributedString(string: value, attributes: textAttributes)
  }
}
