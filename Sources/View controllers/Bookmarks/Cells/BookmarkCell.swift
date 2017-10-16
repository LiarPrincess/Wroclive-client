//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import SnapKit

private typealias Layout = BookmarksViewControllerConstants.Layout.Cell

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

class BookmarkCell: UITableViewCell {

  // MARK: - Properties

  let bookmarkName = UILabel()
  let tramLines    = UILabel()
  let busLines     = UILabel()

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    self.bookmarkName.numberOfLines = 0
    self.tramLines.numberOfLines    = 0
    self.busLines.numberOfLines     = 0

    self.contentView.addSubview(self.bookmarkName)
    self.bookmarkName.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }

    self.contentView.addSubview(self.tramLines)
    self.tramLines.snp.makeConstraints { make in
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(Layout.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }

    self.contentView.addSubview(self.busLines)
    self.busLines.snp.makeConstraints { make in
      make.top.equalTo(self.tramLines.snp.bottom).offset(Layout.verticalSpacing)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriden

  // disable alpha, so we dont end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  override func willTransition(to state: UITableViewCellStateMask) {
    super.willTransition(to: state)
    self.disallowIndentWhileEditing()
  }

  override func layoutSubviews() {
    self.updateLabelPreferredWidths()
    super.layoutSubviews()
    self.disallowIndentWhileEditing()
  }

  private func updateLabelPreferredWidths() {
    // hack: we need to calculate from cell not content view as content view will shrink on edit
    let labelWidth = self.bounds.width - Layout.leftInset - Layout.rightInset
    self.bookmarkName.preferredMaxLayoutWidth = labelWidth
    self.tramLines.preferredMaxLayoutWidth    = labelWidth
    self.busLines.preferredMaxLayoutWidth     = labelWidth
  }

  private func disallowIndentWhileEditing() {
    if self.isEditing {
      self.contentView.frame.origin.x   = self.bounds.minX
      self.contentView.frame.size.width = self.bounds.maxX
    }
  }

  override func updateConstraints() {
    func calculateTopOffset(for label: UILabel) -> CGFloat {
      let text = label.text
      let isTextEmpty = text == nil || text!.isEmpty
      return isTextEmpty ? 0.0 : Layout.verticalSpacing
    }

    self.tramLines.snp.updateConstraints { make in
      let topOffset = calculateTopOffset(for: self.tramLines)
      make.top.equalTo(self.bookmarkName.snp.bottom).offset(topOffset)
    }

    self.busLines.snp.updateConstraints { make in
      let topOffset = calculateTopOffset(for: self.busLines)
      make.top.equalTo(self.tramLines.snp.bottom).offset(topOffset)
    }

    super.updateConstraints()
  }

  // MARK: - Methods

  func setUp(with viewModel: BookmarkCellViewModel) {
    self.backgroundColor = viewModel.theme.colorScheme.background

    let nameAttributes = viewModel.theme.textAttributes(for: .subheadline, alignment: .center)
    self.bookmarkName.attributedText = NSAttributedString(string: viewModel.bookmarkName, attributes: nameAttributes)

    self.setLineLabel(self.tramLines, text: viewModel.tramLines, theme: viewModel.theme)
    self.setLineLabel(self.busLines,  text: viewModel.busLines,  theme: viewModel.theme)

    // update constraints, so that the layout will not break when we hide label
    self.setNeedsUpdateConstraints()
    self.setNeedsLayout()
  }

  private func setLineLabel(_ label: UILabel, text: String, theme: ThemeManager) {
    let textAttributes   = theme.textAttributes(for: .body, alignment: .center, lineSpacing: Layout.LinesLabel.lineSpacing, color: .tint)
    label.isHidden       = text.isEmpty
    label.attributedText = NSAttributedString(string: text, attributes: textAttributes)
  }
}
