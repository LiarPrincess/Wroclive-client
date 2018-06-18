//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = LineSelectorCellConstants.Layout

class LineSelectorCell: UICollectionViewCell {

  // MARK: - Properties

  private let textLabel = UILabel()
  private var viewModel: LineSelectorCellViewModel?

  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  override var isSelected: Bool {
    didSet { self.updateTextLabel() }
  }

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
    self.selectedBackgroundView?.backgroundColor    = AppEnvironment.theme.colors.tint
    self.selectedBackgroundView?.layer.cornerRadius = Layout.cornerRadius

    self.textLabel.numberOfLines = 1
    self.textLabel.isUserInteractionEnabled = false

    self.contentView.addSubview(self.textLabel)
    self.textLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - Methods

  func update(from viewModel: LineSelectorCellViewModel) {
    // note that self.isSelected for new cell is set BEFORE tableView(_:cellForRowAt:) is called
    self.viewModel = viewModel
    self.updateTextLabel()
  }

  private func updateTextLabel() {
    self.viewModel?.updateText(isCellSelected: self.isSelected)
    self.textLabel.attributedText = self.viewModel?.text
  }
}
