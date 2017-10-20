//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

private typealias Layout = BookmarksViewControllerConstants.Layout.Cell

struct BookmarkCellViewModel {
  let bookmark:     Bookmark
  var bookmarkName: String { return self.bookmark.name }

  let tramLines: String
  let busLines:  String

  init(for bookmark: Bookmark) {
    self.bookmark  = bookmark
    self.tramLines = BookmarkCellViewModel.concatNames(bookmark.lines.filter(.tram))
    self.busLines  = BookmarkCellViewModel.concatNames(bookmark.lines.filter(.bus ))
  }

  private static func concatNames(_ lines: [Line]) -> String {
    return lines
      .sortedByName()
      .map { (line: Line) in line.name }
      .joined(separator: Layout.LinesLabel.horizontalSpacing)
  }
}
