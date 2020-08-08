// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = LineSelectorConstants.Cell

internal final class LineSelectorCell: UICollectionViewCell {

  // MARK: - Properties

  private var line: Line?
  private let label = UILabel()

  internal override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  internal override var isSelected: Bool {
    didSet { self.updateTextLabel() }
  }

  // MARK: - Init

  internal override init(frame: CGRect) {
    super.init(frame: frame)
    self.initLayout()
  }

  internal required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.selectedBackgroundView = UIView()
    self.selectedBackgroundView?.backgroundColor = Theme.colors.tint
    self.selectedBackgroundView?.layer.cornerRadius = Constants.cornerRadius

    self.label.numberOfLines = 1
    self.label.isUserInteractionEnabled = false

    self.contentView.addSubview(self.label)
    self.label.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  // MARK: - Methods

  internal func update(line: Line) {
    // Note that 'self.isSelected' for new cell is set BEFORE
    // 'tableView(_:cellForRowAt:)' is called
    self.updateTextLabel()
  }

  private func updateTextLabel() {
    guard let line = self.line else {
      return
    }

    let text = Self.createText(line: line, isSelected: self.isSelected)
    self.label.attributedText = text
  }

  internal static func createText(line: Line,
                                  isSelected: Bool) -> NSAttributedString {
    let string = line.name.uppercased()
    let attributes = isSelected ?
      Constants.selectedTextAttributes :
      Constants.notSelectedTextAttributes

    return NSAttributedString(string: string, attributes: attributes)
  }
}
