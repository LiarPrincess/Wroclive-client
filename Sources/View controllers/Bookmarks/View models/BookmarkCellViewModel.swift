//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

struct BookmarkCellViewModel {
  let bookmark:     Bookmark
  var bookmarkName: String { return self.bookmark.name }

  var lines: [Line] { return self.bookmark.lines }
  let lineViewModels: [[BookmarkCellLineViewModel]]

  init(from bookmark: Bookmark) {
    self.bookmark = bookmark

    let tramViewModels = bookmark.lines.filter { $0.type == .tram }.map { BookmarkCellLineViewModel(from: $0) }
    let busViewModels  = bookmark.lines.filter { $0.type == .bus  }.map { BookmarkCellLineViewModel(from: $0) }
    self.lineViewModels = [tramViewModels, busViewModels]
  }

}
