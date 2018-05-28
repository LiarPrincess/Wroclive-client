//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

private typealias Layout     = BookmarksCellConstants.Layout
private typealias TextStyles = BookmarksCellConstants.TextStyles

struct BookmarkCellViewModel {
  let name:  NSAttributedString
  let lines: NSAttributedString

  init(_ bookmark: Bookmark) {
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
    .sorted(by: .name)
    .map { (line: Line) in line.name }
    .joined(separator: Layout.LinesLabel.horizontalSpacing)
}
