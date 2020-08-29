// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

private typealias Constants = BookmarksCard.Constants.Cell

// https://stackoverflow.com/a/25967370 - preferredMaxLayoutWidth
// https://stackoverflow.com/a/18746930 - auto layout for UITableView
// https://stackoverflow.com/a/2063776  - recalculate cell height

public final class BookmarksCell: UITableViewCell {

  // MARK: - Properties

  private let nameLabel = UILabel()
  private let linesLabel = UILabel()

  // Disable alpha, so we don't end up with transparent cells when reordering
  override public var alpha: CGFloat {
    get { return 1.0 }
    set {} // swiftlint:disable:this unused_setter_value
  }

  // MARK: - Init

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initLayout()
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initLayout() {
    self.backgroundColor = ColorScheme.background

    self.nameLabel.numberOfLines = 0
    self.nameLabel.adjustsFontForContentSizeCategory = true

    self.contentView.addSubview(self.nameLabel)
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Constants.topInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }

    self.linesLabel.numberOfLines = 0
    self.linesLabel.adjustsFontForContentSizeCategory = true

    self.contentView.addSubview(self.linesLabel)
    self.linesLabel.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.Lines.topMargin)
      make.bottom.equalToSuperview().offset(-Constants.bottomInset)
      make.left.equalToSuperview().offset(Constants.leftInset)
      make.right.equalToSuperview().offset(-Constants.rightInset)
    }
  }

  // MARK: - Overriden

  override public func willTransition(to state: UITableViewCell.StateMask) {
    super.willTransition(to: state)
    self.disallowIndentWhileEditing()
  }

  override public func layoutSubviews() {
    self.updateLabelPreferredWidths()
    super.layoutSubviews()
    self.disallowIndentWhileEditing()
  }

  private func disallowIndentWhileEditing() {
    if self.isEditing {
      self.contentView.frame.origin.x = self.bounds.minX
      self.contentView.frame.size.width = self.bounds.maxX
    }
  }

  private func updateLabelPreferredWidths() {
    // HACK: We need to calculate from cell not content view as content view
    // will shrink on edit.
    let labelWidth = self.bounds.width - Constants.leftInset - Constants.rightInset
    self.nameLabel.preferredMaxLayoutWidth = labelWidth
    self.linesLabel.preferredMaxLayoutWidth = labelWidth
  }

  // MARK: - Methods

  public func update(bookmark: Bookmark) {
    let name = Self.createNameText(bookmark: bookmark)
    let lines = Self.createLinesText(bookmark: bookmark)

    self.nameLabel.attributedText = name
    self.linesLabel.attributedText = lines
  }

  internal static func createNameText(bookmark: Bookmark) -> NSAttributedString {
    let string = bookmark.name
    let attributes = Constants.Name.attributes
    return NSAttributedString(string: string, attributes: attributes)
  }

  internal static func createLinesText(bookmark: Bookmark) -> NSAttributedString {
    var tramLines = [Line]()
    var busLines = [Line]()

    for line in bookmark.lines {
      switch line.type {
      case .tram: tramLines.append(line)
      case .bus: busLines.append(line)
      }
    }

    tramLines.sortByLocalizedName()
    busLines.sortByLocalizedName()

    let hasTramLines = tramLines.any
    let hasBusLines = busLines.any
    let hasTramAndBusLines = hasTramLines && hasBusLines

    var string = ""
    if hasTramLines { string += self.concat(lines: tramLines) }
    if hasTramAndBusLines { string += "\n" }
    if hasBusLines { string += self.concat(lines: busLines) }

    let attributes = Constants.Lines.attributes
    return NSAttributedString(string: string, attributes: attributes)
  }

  private static func concat(lines: [Line]) -> String {
    var result = ""
    for (index, line) in lines.enumerated() {
      if index != 0 {
        let separator = Constants.Lines.horizontalSpacing
        result.append(separator)
      }

      result.append(line.name)
    }

    return result
  }
}
