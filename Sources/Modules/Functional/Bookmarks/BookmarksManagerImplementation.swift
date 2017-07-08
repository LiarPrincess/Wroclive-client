//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManagerImplementation: BookmarksManager {

  // MARK: - Properties

  private var bookmarks = BookmarksManagerImplementation.testData()

  // MARK: - BookmarksManager

  func addNew(name: String, lines: [Line]) -> Bookmark {
    let maxOrder = self.bookmarks.map { $0.order }.max() ?? 0

    let bookmarkLines = lines.map { BookmarkLine(id: 0, name: $0.name, type: $0.type, subtype: $0.subtype) }
    let bookmark      = Bookmark(id: 0, name: name, lines: bookmarkLines, order: maxOrder + 1)

    self.bookmarks.append(bookmark)
    return bookmark
  }

  func save(_ bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

}

extension BookmarksManagerImplementation {

  fileprivate static func testData() -> [Bookmark] {
    let line1 = BookmarkLine(id: 0, name: "1", type: .tram, subtype: .regular)
    let line2 = BookmarkLine(id: 0, name: "2", type: .tram, subtype: .regular)
    let line3 = BookmarkLine(id: 0, name: "3", type: .tram, subtype: .regular)
    let line4 = BookmarkLine(id: 0, name: "4", type: .tram, subtype: .regular)
    let line5 = BookmarkLine(id: 0, name: "5", type: .tram, subtype: .regular)
    let line6 = BookmarkLine(id: 0, name: "6", type: .tram, subtype: .regular)
    let line7 = BookmarkLine(id: 0, name: "7", type: .tram, subtype: .regular)
    let line8 = BookmarkLine(id: 0, name: "8", type: .tram, subtype: .regular)
    let line9 = BookmarkLine(id: 0, name: "9", type: .tram, subtype: .regular)

    let line0L = BookmarkLine(id: 0, name: "0L", type: .tram, subtype: .regular)
    let line0P = BookmarkLine(id: 0, name: "0P", type: .tram, subtype: .regular)

    let line31 = BookmarkLine(id: 0, name: "31", type: .tram, subtype: .regular)
    let line32 = BookmarkLine(id: 0, name: "32", type: .tram, subtype: .regular)
    let line33 = BookmarkLine(id: 0, name: "33", type: .tram, subtype: .regular)

    let lineA = BookmarkLine(id: 0, name: "A", type: .bus, subtype: .express)
    let lineC = BookmarkLine(id: 0, name: "C", type: .bus, subtype: .express)
    let lineD = BookmarkLine(id: 0, name: "D", type: .bus, subtype: .express)
    let lineK = BookmarkLine(id: 0, name: "K", type: .bus, subtype: .express)
    let lineN = BookmarkLine(id: 0, name: "N", type: .bus, subtype: .express)

    let line100 = BookmarkLine(id: 0, name: "100", type: .bus, subtype: .regular)
    let line101 = BookmarkLine(id: 0, name: "101", type: .bus, subtype: .regular)
    let line102 = BookmarkLine(id: 0, name: "102", type: .bus, subtype: .regular)
    let line103 = BookmarkLine(id: 0, name: "103", type: .bus, subtype: .regular)
    let line104 = BookmarkLine(id: 0, name: "104", type: .bus, subtype: .regular)
    let line105 = BookmarkLine(id: 0, name: "105", type: .bus, subtype: .regular)
    let line106 = BookmarkLine(id: 0, name: "106", type: .bus, subtype: .regular)
    let line107 = BookmarkLine(id: 0, name: "107", type: .bus, subtype: .regular)
    let line109 = BookmarkLine(id: 0, name: "109", type: .bus, subtype: .regular)
    let line110 = BookmarkLine(id: 0, name: "110", type: .bus, subtype: .regular)

    let line247 = BookmarkLine(id: 0, name: "247", type: .bus, subtype: .night)
    let line248 = BookmarkLine(id: 0, name: "248", type: .bus, subtype: .night)
    let line249 = BookmarkLine(id: 0, name: "249", type: .bus, subtype: .night)
    let line250 = BookmarkLine(id: 0, name: "250", type: .bus, subtype: .night)
    let line251 = BookmarkLine(id: 0, name: "251", type: .bus, subtype: .night)

    let line305 = BookmarkLine(id: 0, name: "305", type: .bus, subtype: .regular)
    let line319 = BookmarkLine(id: 0, name: "319", type: .bus, subtype: .regular)
    let line325 = BookmarkLine(id: 0, name: "325", type: .bus, subtype: .regular)
    let line331 = BookmarkLine(id: 0, name: "331", type: .bus, subtype: .regular)

    let line602 = BookmarkLine(id: 0, name: "602", type: .bus, subtype: .suburban)
    let line607 = BookmarkLine(id: 0, name: "607", type: .bus, subtype: .suburban)
    let line609 = BookmarkLine(id: 0, name: "609", type: .bus, subtype: .suburban)
    let line612 = BookmarkLine(id: 0, name: "612", type: .bus, subtype: .suburban)

    let allBusExpress = [lineA, lineC, lineD, lineK, lineN]
    let allBusRegular = [line100, line101, line102, line103, line104, line105, line106, line107, line109, line110]
    let allBusNight = [line247, line248, line249, line250, line251]
    let allBusRegular2 = [line305, line319, line325, line331]
    let allBusSuburban = [line602, line607, line609, line612]

    let allTrams = [line1, line2, line3, line4, line5, line6, line7, line8, line9, line0L, line0P, line31, line32, line33]
    let allBus = allBusExpress + allBusRegular + allBusNight + allBusRegular2 + allBusSuburban

    let b1 = Bookmark(id: 1, name: "University", lines: allTrams + allBus, order: 1)
    let b2 = Bookmark(id: 2, name: "All tram",   lines: allTrams,          order: 2)
    let b3 = Bookmark(id: 3, name: "All bus",    lines: allBus,            order: 3)

    return [b2, b3, b1]
  }

}
