////
////  Created by Michal Matuszczyk
////  Copyright © 2017 Michal Matuszczyk. All rights reserved.
////
//
//class ScreenshotBookmarksManager: BookmarksManager {
//
//  func addNew(name: String, lines: [Line]) -> Bookmark {
//    return Bookmark(name: "", lines: [])
//  }
//
//  func getAll() -> [Bookmark] {
//    let tram1 = Line(name: "1", type: .tram, subtype: .regular)
//    let tram2 = Line(name: "2", type: .tram, subtype: .regular)
//    let tram3 = Line(name: "3", type: .tram, subtype: .regular)
//    let tram4 = Line(name: "4", type: .tram, subtype: .regular)
//    let tram5 = Line(name: "5", type: .tram, subtype: .regular)
//    let tram6 = Line(name: "6", type: .tram, subtype: .regular)
//    let tram7 = Line(name: "7", type: .tram, subtype: .regular)
//    let tram8 = Line(name: "8", type: .tram, subtype: .regular)
//    let tram9 = Line(name: "9", type: .tram, subtype: .regular)
//    let busA = Line(name: "A", type: .bus, subtype: .express)
//    let busD = Line(name: "D", type: .bus, subtype: .express)
//    let busK = Line(name: "K", type: .bus, subtype: .express)
//    let busN = Line(name: "N", type: .bus, subtype: .express)
//    let tram0L = Line(name: "0L", type: .tram, subtype: .regular)
//    let tram0P = Line(name: "0P", type: .tram, subtype: .regular)
//    let tram10 = Line(name: "10", type: .tram, subtype: .regular)
//    let tram11 = Line(name: "11", type: .tram, subtype: .regular)
//    let tram14 = Line(name: "14", type: .tram, subtype: .regular)
//    let tram15 = Line(name: "15", type: .tram, subtype: .regular)
//    let tram17 = Line(name: "17", type: .tram, subtype: .regular)
//    let tram20 = Line(name: "20", type: .tram, subtype: .regular)
//    let tram23 = Line(name: "23", type: .tram, subtype: .regular)
//    let tram24 = Line(name: "24", type: .tram, subtype: .regular)
//    let tram31 = Line(name: "31", type: .tram, subtype: .regular)
//    let tram32 = Line(name: "32", type: .tram, subtype: .regular)
//    let tram33 = Line(name: "33", type: .tram, subtype: .regular)
//    let busC = Line(name: "C", type: .bus, subtype: .express)
//    let bus100 = Line(name: "100", type: .bus, subtype: .regular)
//    let bus101 = Line(name: "101", type: .bus, subtype: .regular)
//    let bus102 = Line(name: "102", type: .bus, subtype: .regular)
//    let bus103 = Line(name: "103", type: .bus, subtype: .regular)
//    let bus104 = Line(name: "104", type: .bus, subtype: .regular)
//    let bus105 = Line(name: "105", type: .bus, subtype: .regular)
//    let bus106 = Line(name: "106", type: .bus, subtype: .regular)
//    let bus107 = Line(name: "107", type: .bus, subtype: .regular)
//    let bus109 = Line(name: "109", type: .bus, subtype: .regular)
//    let bus110 = Line(name: "110", type: .bus, subtype: .regular)
//    let bus112 = Line(name: "112", type: .bus, subtype: .regular)
//    let bus113 = Line(name: "113", type: .bus, subtype: .regular)
//    let bus114 = Line(name: "114", type: .bus, subtype: .regular)
//    let bus115 = Line(name: "115", type: .bus, subtype: .regular)
//    let bus118 = Line(name: "118", type: .bus, subtype: .regular)
//    let bus119 = Line(name: "119", type: .bus, subtype: .regular)
//    let bus120 = Line(name: "120", type: .bus, subtype: .regular)
//    let bus122 = Line(name: "122", type: .bus, subtype: .regular)
//    let bus125 = Line(name: "125", type: .bus, subtype: .regular)
//    let bus126 = Line(name: "126", type: .bus, subtype: .regular)
//    let bus127 = Line(name: "127", type: .bus, subtype: .regular)
//    let bus129 = Line(name: "129", type: .bus, subtype: .regular)
//    let bus130 = Line(name: "130", type: .bus, subtype: .regular)
//    let bus131 = Line(name: "131", type: .bus, subtype: .regular)
//    let bus132 = Line(name: "132", type: .bus, subtype: .regular)
//    let bus133 = Line(name: "133", type: .bus, subtype: .regular)
//    let bus134 = Line(name: "134", type: .bus, subtype: .regular)
//    let bus136 = Line(name: "136", type: .bus, subtype: .regular)
//    let bus140 = Line(name: "140", type: .bus, subtype: .regular)
//    let bus141 = Line(name: "141", type: .bus, subtype: .regular)
//    let bus142 = Line(name: "142", type: .bus, subtype: .regular)
//    let bus144 = Line(name: "144", type: .bus, subtype: .regular)
//    let bus145 = Line(name: "145", type: .bus, subtype: .regular)
//    let bus146 = Line(name: "146", type: .bus, subtype: .regular)
//    let bus147 = Line(name: "147", type: .bus, subtype: .regular)
//    let bus148 = Line(name: "148", type: .bus, subtype: .regular)
//    let bus149 = Line(name: "149", type: .bus, subtype: .regular)
//    let bus150 = Line(name: "150", type: .bus, subtype: .regular)
//    let bus206 = Line(name: "206", type: .bus, subtype: .night)
//    let bus240 = Line(name: "240", type: .bus, subtype: .night)
//    let bus241 = Line(name: "241", type: .bus, subtype: .night)
//    let bus243 = Line(name: "243", type: .bus, subtype: .night)
//    let bus245 = Line(name: "245", type: .bus, subtype: .night)
//    let bus246 = Line(name: "246", type: .bus, subtype: .night)
//    let bus247 = Line(name: "247", type: .bus, subtype: .night)
//    let bus248 = Line(name: "248", type: .bus, subtype: .night)
//    let bus249 = Line(name: "249", type: .bus, subtype: .night)
//    let bus250 = Line(name: "250", type: .bus, subtype: .night)
//    let bus251 = Line(name: "251", type: .bus, subtype: .night)
//    let bus253 = Line(name: "253", type: .bus, subtype: .night)
//    let bus255 = Line(name: "255", type: .bus, subtype: .night)
//    let bus257 = Line(name: "257", type: .bus, subtype: .night)
//    let bus259 = Line(name: "259", type: .bus, subtype: .night)
//    let bus319 = Line(name: "319", type: .bus, subtype: .regular)
//    let bus325 = Line(name: "325", type: .bus, subtype: .regular)
//    let bus331 = Line(name: "331", type: .bus, subtype: .regular)
//    let bus602 = Line(name: "602", type: .bus, subtype: .suburban)
//    let bus607 = Line(name: "607", type: .bus, subtype: .suburban)
//    let bus609 = Line(name: "609", type: .bus, subtype: .suburban)
//    let bus612 = Line(name: "612", type: .bus, subtype: .suburban)
//    let bus116 = Line(name: "116", type: .bus, subtype: .regular)
//    let bus128 = Line(name: "128", type: .bus, subtype: .regular)
//
//    let universityLines = [tram0L, tram0P, tram1, tram10, tram33, busA, busC, busD, bus145, bus146, bus149]
//    let university = Bookmark(name: "Uczelnia", lines: universityLines)
//
//    let workLines = [tram3, tram4, tram10, tram20, tram31, tram32, tram33, bus319, bus126, bus134, bus136]
//    let work = Bookmark(name: "Praca", lines: workLines)
//
//    let cityLines = [tram4, tram5, tram11, tram14, tram20, tram24, busA, busD, bus107, bus125, bus319, bus325]
//    let city = Bookmark(name: "Miasto", lines: cityLines)
//
//    let nightLines = [bus241, bus246, bus248, bus251, bus257]
//    let night = Bookmark(name: "Nocne", lines: nightLines)
//
//    return [university, work, city, night]
//  }
//
//  func save(_ bookmarks: [Bookmark]) {}
//}
//
//
