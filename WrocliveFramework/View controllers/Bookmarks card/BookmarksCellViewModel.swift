// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

private typealias Constants = BookmarksCard.Constants.Cell

public struct BookmarksCellViewModel: Equatable {

  public let nameText: NSAttributedString
  public let linesText: NSAttributedString
  public let bookmark: Bookmark

  public init(bookmark: Bookmark) {
    self.bookmark = bookmark
    self.nameText = createNameText(bookmark: bookmark)
    self.linesText = createLinesText(bookmark: bookmark)
  }

  public static func == (lhs: BookmarksCellViewModel,
                         rhs: BookmarksCellViewModel) -> Bool {
    return lhs.bookmark == rhs.bookmark
  }
}

private func createNameText(bookmark: Bookmark) -> NSAttributedString {
  let string = bookmark.name
  let attributes = Constants.Name.attributes
  return NSAttributedString(string: string, attributes: attributes)
}

private func createLinesText(bookmark: Bookmark) -> NSAttributedString {
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
  if hasTramLines { string += concat(lines: tramLines) }
  if hasTramAndBusLines { string += "\n" }
  if hasBusLines { string += concat(lines: busLines) }

  let attributes = Constants.Lines.attributes
  return NSAttributedString(string: string, attributes: attributes)
}

private func concat(lines: [Line]) -> String {
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
