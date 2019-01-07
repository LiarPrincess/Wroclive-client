// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

public final class BookmarksCell: UITableViewCell {

  // MARK: - Properties

  private let nameLabel  = UILabel()
  private let linesLabel = UILabel()

  // disable alpha, so we don't end up with transparent cells when reordering
  public override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background
    self.nameLabel.numberOfLines  = 0
    self.linesLabel.numberOfLines = 0

    self.contentView.addSubview(self.nameLabel, constraints: [
      make(\UIView.topAnchor, equalToSuperview: \UIView.topAnchor, constant: Layout.topInset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.rightInset)
    ])

    self.contentView.addSubview(self.linesLabel, constraints: [
      make(\UIView.topAnchor, equalTo: self.nameLabel.bottomAnchor, constant: Layout.LinesLabel.topMargin),
      make(\UIView.bottomAnchor, equalToSuperview: \UIView.bottomAnchor, constant: -Layout.bottomInset),
      make(\UIView.leftAnchor, equalToSuperview: \UIView.leftAnchor, constant: Layout.leftInset),
      make(\UIView.rightAnchor, equalToSuperview: \UIView.rightAnchor, constant: -Layout.rightInset)
    ])
  }

  // MARK: - Overriden

  public override func willTransition(to state: UITableViewCell.StateMask) {
    super.willTransition(to: state)
    self.disallowIndentWhileEditing()
  }

  public override func layoutSubviews() {
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

  public func update(from viewModel: BookmarkCellViewModel) {
    self.nameLabel.attributedText  = viewModel.name
    self.linesLabel.attributedText = viewModel.lines
  }
}
