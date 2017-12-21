//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout     = BookmarkCellConstants.Layout
private typealias TextStyles = BookmarkCellConstants.TextStyles

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

class BookmarkCell: UITableViewCell {

  // MARK: - Properties

  let nameLabel  = UILabel()
  let linesLabel = UILabel()

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.backgroundColor = Managers.theme.colors.background

    self.nameLabel.numberOfLines  = 0
    self.linesLabel.numberOfLines = 0

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }

    self.contentView.addSubview(self.linesLabel)
    self.linesLabel.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(Layout.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  override func willTransition(to state: UITableViewCellStateMask) {
    super.willTransition(to: state)
    self.disallowIndentWhileEditing()
  }

  override func layoutSubviews() {
    self.updateLabelPreferredWidths()
    super.layoutSubviews()
    self.disallowIndentWhileEditing()
  }

  private func disallowIndentWhileEditing() {
    if self.isEditing {
      self.contentView.frame.origin.x   = self.bounds.minX
      self.contentView.frame.size.width = self.bounds.maxX
    }
  }

  private func updateLabelPreferredWidths() {
    // hack: we need to calculate from cell not content view as content view will shrink on edit
    let labelWidth = self.bounds.width - Layout.leftInset - Layout.rightInset
    self.nameLabel.preferredMaxLayoutWidth  = labelWidth
    self.linesLabel.preferredMaxLayoutWidth = labelWidth
  }

  // MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    let name = viewModel.bookmarkName
    self.nameLabel.attributedText = NSAttributedString(string: name, attributes: TextStyles.name.value)

    let lines = self.createLineLabelText(tramLines: viewModel.tramLines, busLines: viewModel.busLines)
    self.linesLabel.attributedText = NSAttributedString(string: lines, attributes: TextStyles.lines.value)
  }

  private func createLineLabelText(tramLines: String, busLines: String) -> String {
    let hasTramLines = !tramLines.isEmpty
    let hasBusLines  = !busLines.isEmpty

    var result = ""
    if hasTramLines {
      result += tramLines
    }

    if hasTramLines && hasBusLines {
      result += "\n"
    }

    if hasBusLines {
      result += busLines
    }

    return result
  }
}
