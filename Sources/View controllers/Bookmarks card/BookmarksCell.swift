// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

class BookmarksCell: UITableViewCell {

  // MARK: - Properties

  private let nameLabel  = UILabel()
  private let linesLabel = UILabel()

  // disable alpha, so we don't end up with transparent cells when reordering
  override var alpha: CGFloat {
    get { return 1.0 }
    set { }
  }

  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = Theme.colors.background
    self.nameLabel.numberOfLines  = 0
    self.linesLabel.numberOfLines = 0

    self.contentView.addSubview(self.nameLabel, constraints: [
      self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Layout.topInset),
      self.nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Layout.leftInset),
      self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Layout.rightInset)
    ])

    self.contentView.addSubview(self.linesLabel, constraints: [
      self.linesLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: Layout.LinesLabel.topMargin),
      self.linesLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Layout.bottomInset),
      self.linesLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: Layout.leftInset),
      self.linesLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -Layout.rightInset)
    ])
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

  func update(from viewModel: BookmarkCellViewModel) {
    self.nameLabel.attributedText  = viewModel.name
    self.linesLabel.attributedText = viewModel.lines
  }
}
