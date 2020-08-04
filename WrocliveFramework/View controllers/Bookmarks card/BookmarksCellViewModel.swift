// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

public struct BookmarkCellViewModel {
  public let name: NSAttributedString
  public let lines: NSAttributedString

  public init(bookmark: Bookmark) {
    let linesText = createLinesLabel(bookmark)
    self.name = NSAttributedString(string: bookmark.name, attributes: TextStyles.name)
    self.lines = NSAttributedString(string: linesText, attributes: TextStyles.lines)
  }
}

private func createLinesLabel(_ bookmark: Bookmark) -> String {
  var tramLines = bookmark.lines.filter(.tram)
  var busLines = bookmark.lines.filter(.bus)

  tramLines.sortByLocalizedName()
  busLines.sortByLocalizedName()

  let hasTramLines = tramLines.any
  let hasBusLines = busLines.any
  let hasTramAndBusLines = hasTramLines && hasBusLines

  var result = ""
  if hasTramLines       { result += concatNames(lines: tramLines) }
  if hasTramAndBusLines { result += "\n" }
  if hasBusLines        { result += concatNames(lines: busLines) }

  return result
}

private func concatNames(lines: [Line]) -> String {
  return lines
    .map { (line: Line) in line.name }
    .joined(separator: Layout.LinesLabel.horizontalSpacing)
}
