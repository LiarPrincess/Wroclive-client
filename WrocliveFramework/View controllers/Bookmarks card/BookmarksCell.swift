// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Layout = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

public final class BookmarksCell: UITableViewCell {

  // MARK: - Properties

  private let nameLabel  = UILabel()
  private let linesLabel = UILabel()

  // Disable alpha, so we don't end up with transparent cells when reordering
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

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Layout.topInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }

    self.contentView.addSubview(self.linesLabel)
    self.linesLabel.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(Layout.LinesLabel.topMargin)
      make.bottom.equalToSuperview().offset(-Layout.bottomInset)
      make.left.equalToSuperview().offset(Layout.leftInset)
      make.right.equalToSuperview().offset(-Layout.rightInset)
    }
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
    // HACK: We need to calculate from cell not content view as content view
    // will shrink on edit.
    let labelWidth = self.bounds.width - Layout.leftInset - Layout.rightInset
    self.nameLabel.preferredMaxLayoutWidth  = labelWidth
    self.linesLabel.preferredMaxLayoutWidth = labelWidth
  }

  // MARK: - Methods

  public func update(bookmark: Bookmark) {
    let name = Self.createNameText(bookmark: bookmark)
    let lines = Self.createLinesText(bookmark: bookmark)

    self.nameLabel.attributedText  = name
    self.linesLabel.attributedText = lines
  }

  internal static func createNameText(bookmark: Bookmark) -> NSAttributedString {
    return NSAttributedString(string: bookmark.name, attributes: TextStyles.name)
  }

  internal static func createLinesText(bookmark: Bookmark) -> NSAttributedString {
    var tramLines = bookmark.lines.filter(.tram)
    var busLines = bookmark.lines.filter(.bus)

    tramLines.sortByLocalizedName()
    busLines.sortByLocalizedName()

    let hasTramLines = tramLines.any
    let hasBusLines = busLines.any
    let hasTramAndBusLines = hasTramLines && hasBusLines

    var string = ""
    if hasTramLines       { string += concat(lines: tramLines) }
    if hasTramAndBusLines { string += "\n" }
    if hasBusLines        { string += concat(lines: busLines) }

    return NSAttributedString(string: string, attributes: TextStyles.lines)
  }

  private static func concat(lines: [Line]) -> String {
    var result = ""
    for (index, line) in lines.enumerated() {
      if index != 0 {
        let separator = Layout.LinesLabel.horizontalSpacing
        result.append(separator)
      }

      result.append(line.name)
    }

    return result
  }
}
