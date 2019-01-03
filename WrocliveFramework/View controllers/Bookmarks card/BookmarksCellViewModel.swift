// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

public struct BookmarkCellViewModel {
  public let name:  NSAttributedString
  public let lines: NSAttributedString

  public init(_ bookmark: Bookmark) {
    self.name  = NSAttributedString(string: bookmark.name,              attributes: TextStyles.name)
    self.lines = NSAttributedString(string: createLinesLabel(bookmark), attributes: TextStyles.lines)
  }
}

private func createLinesLabel(_ bookmark: Bookmark) -> String {
  let tramLines = bookmark.lines.filter(.tram)
  let busLines  = bookmark.lines.filter(.bus)

  let hasTramLines = tramLines.any
  let hasBusLines  = busLines.any
  let hasTramAndBusLines = hasTramLines && hasBusLines

  var result = ""
  if hasTramLines       { result += concatNames(tramLines) }
  if hasTramAndBusLines { result += "\n" }
  if hasBusLines        { result += concatNames(busLines) }

  return result
}

private func concatNames(_ lines: [Line]) -> String {
  return lines
    .sortedByName()
    .map { (line: Line) in line.name }
    .joined(separator: Layout.LinesLabel.horizontalSpacing)
}
