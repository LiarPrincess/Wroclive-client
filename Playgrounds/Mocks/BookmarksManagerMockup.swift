//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class BookmarksManagerMockup: BookmarksManager {

  private var bookmarks: [Bookmark]

  fileprivate init(with bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

  func addNew(name: String, lines: [Line]) -> Bookmark {
    let newBookmark = Bookmark(name: name, lines: lines)
    self.bookmarks.append(newBookmark)
    return newBookmark
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(_ bookmarks: [Bookmark]) {
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }
}

extension BookmarksManagerMockup {
  static var empty: BookmarksManager { return BookmarksManagerMockup(with: []) }

  static var filled: BookmarksManager {
    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
    let tram3 = Line(name: "3", type: .tram, subtype: .regular)
    let tram4 = Line(name: "4", type: .tram, subtype: .regular)
    let tram5 = Line(name: "5", type: .tram, subtype: .regular)
    let busA = Line(name: "A", type: .bus, subtype: .express)
    let busC = Line(name: "C", type: .bus, subtype: .express)
    let busD = Line(name: "D", type: .bus, subtype: .express)
    let tram0L = Line(name: "0L", type: .tram, subtype: .regular)
    let tram0P = Line(name: "0P", type: .tram, subtype: .regular)
    let tram10 = Line(name: "10", type: .tram, subtype: .regular)
    let tram11 = Line(name: "11", type: .tram, subtype: .regular)
    let tram14 = Line(name: "14", type: .tram, subtype: .regular)
    let tram20 = Line(name: "20", type: .tram, subtype: .regular)
    let tram24 = Line(name: "24", type: .tram, subtype: .regular)
    let tram31 = Line(name: "31", type: .tram, subtype: .regular)
    let tram32 = Line(name: "32", type: .tram, subtype: .regular)
    let tram33 = Line(name: "33", type: .tram, subtype: .regular)
    let bus107 = Line(name: "107", type: .bus, subtype: .regular)
    let bus125 = Line(name: "125", type: .bus, subtype: .regular)
    let bus126 = Line(name: "126", type: .bus, subtype: .regular)
    let bus134 = Line(name: "134", type: .bus, subtype: .regular)
    let bus136 = Line(name: "136", type: .bus, subtype: .regular)
    let bus145 = Line(name: "145", type: .bus, subtype: .regular)
    let bus146 = Line(name: "146", type: .bus, subtype: .regular)
    let bus149 = Line(name: "149", type: .bus, subtype: .regular)
    let bus241 = Line(name: "241", type: .bus, subtype: .night)
    let bus246 = Line(name: "246", type: .bus, subtype: .night)
    let bus248 = Line(name: "248", type: .bus, subtype: .night)
    let bus251 = Line(name: "251", type: .bus, subtype: .night)
    let bus257 = Line(name: "257", type: .bus, subtype: .night)
    let bus319 = Line(name: "319", type: .bus, subtype: .regular)
    let bus325 = Line(name: "325", type: .bus, subtype: .regular)

    let universityLines: [Line] = [tram0L, tram0P, tram1, tram10, tram33, busA, busC, busD, bus145, bus146, bus149]
    let workLines:       [Line] = [tram3, tram4, tram10, tram20, tram31, tram32, tram33, bus319, bus126, bus134, bus136]
    let cityLines:       [Line] = [tram4, tram5, tram11, tram14, tram20, tram24, busA, busD, bus107, bus125, bus319, bus325]
    let nightLines:      [Line] = [bus241, bus246, bus248, bus251, bus257]

    let university = Bookmark(name: "Uczelnia", lines: universityLines)
    let work       = Bookmark(name: "Praca", lines: workLines)
    let city       = Bookmark(name: "Miasto", lines: cityLines)
    let night      = Bookmark(name: "Nocne", lines: nightLines)

    let bookmarks: [Bookmark] = [university, work, city, night]
    return BookmarksManagerMockup(with: bookmarks)
  }
}
