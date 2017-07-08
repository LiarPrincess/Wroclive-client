//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

fileprivate typealias Layout = BookmarksViewControllerConstants.Layout.Cell

struct BookmarkCellViewModel {
  let bookmark:     Bookmark
  var bookmarkName: String { return self.bookmark.name }

  let tramLines: String
  let busLines:  String

  init(from bookmark: Bookmark) {
    self.bookmark  = bookmark
    self.tramLines = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .tram)
    self.busLines  = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .bus)
  }

  private static func concatNames(_ lines: [Line], ofType lineType: LineType) -> String {
    return lines
      .filter { $0.type == lineType }
      .map    { $0.name }
      .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
      .joined(separator: Layout.LinesLabel.horizontalSpacing)
  }
}
