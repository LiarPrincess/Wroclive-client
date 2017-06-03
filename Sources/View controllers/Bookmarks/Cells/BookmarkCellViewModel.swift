//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct BookmarkCellViewModel {
  let bookmarkName: String
  let tramLines:    String
  let busLines:     String

  init(from bookmark: Bookmark) {
    self.bookmarkName = bookmark.name
    self.tramLines    = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .tram)
    self.busLines     = BookmarkCellViewModel.concatNames(bookmark.lines, ofType: .bus)
  }

  private static func concatNames(_ lines: [Line], ofType lineType: LineType) -> String {
    return lines.filter { $0.type == lineType }
      .map { $0.name }
      .joined(separator: "  ")
  }
  
}
