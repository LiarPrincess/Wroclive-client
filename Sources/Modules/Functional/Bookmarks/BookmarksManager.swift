//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation

class BookmarksManager: BookmarksManagerProtocol {

  // MARK: - Singleton

  static let instance: BookmarksManagerProtocol = BookmarksManager()

  // MARK: - Properties

  private var bookmarks = BookmarksManager.testData()

  // MARK: - Init

  private init() { }

  // MARK: - BookmarksManagerProtocol

  func add(bookmark: Bookmark) {
    self.bookmarks.append(bookmark)
  }

  func getAll() -> [Bookmark] {
    return self.bookmarks
  }

  func save(bookmarks: [Bookmark]) {
    self.bookmarks = bookmarks
  }

  // MARK: - Methods

  private static func testData() -> [Bookmark] {
    let line1 = Line(name: "1", type: .tram, subtype: .regular)
    let line2 = Line(name: "2", type: .tram, subtype: .regular)
    let line3 = Line(name: "3", type: .tram, subtype: .regular)
    let line4 = Line(name: "4", type: .tram, subtype: .regular)
    let line5 = Line(name: "5", type: .tram, subtype: .regular)
    let line6 = Line(name: "6", type: .tram, subtype: .regular)
    let line7 = Line(name: "7", type: .tram, subtype: .regular)
    let line8 = Line(name: "8", type: .tram, subtype: .regular)
    let line9 = Line(name: "9", type: .tram, subtype: .regular)

    let line0L = Line(name: "0L", type: .tram, subtype: .regular)
    let line0P = Line(name: "0P", type: .tram, subtype: .regular)

    let line31 = Line(name: "31", type: .tram, subtype: .regular)
    let line32 = Line(name: "32", type: .tram, subtype: .regular)
    let line33 = Line(name: "33", type: .tram, subtype: .regular)

    let lineA = Line(name: "A", type: .bus, subtype: .express)
    let lineC = Line(name: "C", type: .bus, subtype: .express)
    let lineD = Line(name: "D", type: .bus, subtype: .express)
    let lineK = Line(name: "K", type: .bus, subtype: .express)
    let lineN = Line(name: "N", type: .bus, subtype: .express)

    let line100 = Line(name: "100", type: .bus, subtype: .regular)
    let line101 = Line(name: "101", type: .bus, subtype: .regular)
    let line102 = Line(name: "102", type: .bus, subtype: .regular)
    let line103 = Line(name: "103", type: .bus, subtype: .regular)
    let line104 = Line(name: "104", type: .bus, subtype: .regular)
    let line105 = Line(name: "105", type: .bus, subtype: .regular)
    let line106 = Line(name: "106", type: .bus, subtype: .regular)
    let line107 = Line(name: "107", type: .bus, subtype: .regular)
    let line109 = Line(name: "109", type: .bus, subtype: .regular)
    let line110 = Line(name: "110", type: .bus, subtype: .regular)

    let line247 = Line(name: "247", type: .bus, subtype: .night)
    let line248 = Line(name: "248", type: .bus, subtype: .night)
    let line249 = Line(name: "249", type: .bus, subtype: .night)
    let line250 = Line(name: "250", type: .bus, subtype: .night)
    let line251 = Line(name: "251", type: .bus, subtype: .night)

    let line305 = Line(name: "305", type: .bus, subtype: .regular)
    let line319 = Line(name: "319", type: .bus, subtype: .regular)
    let line325 = Line(name: "325", type: .bus, subtype: .regular)
    let line331 = Line(name: "331", type: .bus, subtype: .regular)

    let line602 = Line(name: "602", type: .bus, subtype: .suburban)
    let line607 = Line(name: "607", type: .bus, subtype: .suburban)
    let line609 = Line(name: "609", type: .bus, subtype: .suburban)
    let line612 = Line(name: "612", type: .bus, subtype: .suburban)

    let allBusExpress = [lineA, lineC, lineD, lineK, lineN]
    let allBusRegular = [line100, line101, line102, line103, line104, line105, line106, line107, line109, line110]
    let allBusNight = [line247, line248, line249, line250, line251]
    let allBusRegular2 = [line305, line319, line325, line331]
    let allBusSuburban = [line602, line607, line609, line612]

    let allTrams = [line1, line2, line3, line4, line5, line6, line7, line8, line9, line0L, line0P, line31, line32, line33]
    let allBus = allBusExpress + allBusRegular + allBusNight + allBusRegular2 + allBusSuburban

    let b1 = Bookmark(name: "University", lines: allTrams + allBus)
    let b2 = Bookmark(name: "All tram", lines: allTrams)
    let b3 = Bookmark(name: "All bus", lines: allBus)

    return [b2, b3, b1]
  }

}
