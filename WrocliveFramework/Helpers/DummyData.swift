// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#if DEBUG

// swiftlint:disable line_length

import Foundation

/// Data used for tests/screnshots/placeholders etc.
internal enum DummyData {

  internal static let lines = [
    Line(name: "1", type: .tram, subtype: .regular),
    Line(name: "2", type: .tram, subtype: .regular),
    Line(name: "3", type: .tram, subtype: .regular),
    Line(name: "4", type: .tram, subtype: .regular),
    Line(name: "5", type: .tram, subtype: .regular),
    Line(name: "6", type: .tram, subtype: .regular),
    Line(name: "7", type: .tram, subtype: .regular),
    Line(name: "8", type: .tram, subtype: .regular),
    Line(name: "9", type: .tram, subtype: .regular),
    Line(name: "10", type: .tram, subtype: .regular),
    Line(name: "11", type: .tram, subtype: .regular),
    Line(name: "14", type: .tram, subtype: .regular),
    Line(name: "15", type: .tram, subtype: .regular),
    Line(name: "17", type: .tram, subtype: .regular),
    Line(name: "20", type: .tram, subtype: .regular),
    Line(name: "23", type: .tram, subtype: .regular),
    Line(name: "24", type: .tram, subtype: .regular),
    Line(name: "31", type: .tram, subtype: .regular),
    Line(name: "32", type: .tram, subtype: .regular),
    Line(name: "33", type: .tram, subtype: .regular),
    Line(name: "0L", type: .tram, subtype: .regular),
    Line(name: "0P", type: .tram, subtype: .regular),
    Line(name: "A", type: .bus, subtype: .express),
    Line(name: "C", type: .bus, subtype: .express),
    Line(name: "D", type: .bus, subtype: .express),
    Line(name: "K", type: .bus, subtype: .express),
    Line(name: "N", type: .bus, subtype: .express),
    Line(name: "100", type: .bus, subtype: .regular),
    Line(name: "101", type: .bus, subtype: .regular),
    Line(name: "102", type: .bus, subtype: .regular),
    Line(name: "103", type: .bus, subtype: .regular),
    Line(name: "104", type: .bus, subtype: .regular),
    Line(name: "105", type: .bus, subtype: .regular),
    Line(name: "106", type: .bus, subtype: .regular),
    Line(name: "107", type: .bus, subtype: .regular),
    Line(name: "109", type: .bus, subtype: .regular),
    Line(name: "110", type: .bus, subtype: .regular),
    Line(name: "112", type: .bus, subtype: .regular),
    Line(name: "113", type: .bus, subtype: .regular),
    Line(name: "114", type: .bus, subtype: .regular),
    Line(name: "115", type: .bus, subtype: .regular),
    Line(name: "118", type: .bus, subtype: .regular),
    Line(name: "119", type: .bus, subtype: .regular),
    Line(name: "120", type: .bus, subtype: .regular),
    Line(name: "122", type: .bus, subtype: .regular),
    Line(name: "125", type: .bus, subtype: .regular),
    Line(name: "126", type: .bus, subtype: .regular),
    Line(name: "127", type: .bus, subtype: .regular),
    Line(name: "129", type: .bus, subtype: .regular),
    Line(name: "130", type: .bus, subtype: .regular),
    Line(name: "131", type: .bus, subtype: .regular),
    Line(name: "132", type: .bus, subtype: .regular),
    Line(name: "133", type: .bus, subtype: .regular),
    Line(name: "134", type: .bus, subtype: .regular),
    Line(name: "136", type: .bus, subtype: .regular),
    Line(name: "140", type: .bus, subtype: .regular),
    Line(name: "141", type: .bus, subtype: .regular),
    Line(name: "142", type: .bus, subtype: .regular),
    Line(name: "144", type: .bus, subtype: .regular),
    Line(name: "145", type: .bus, subtype: .regular),
    Line(name: "146", type: .bus, subtype: .regular),
    Line(name: "147", type: .bus, subtype: .regular),
    Line(name: "148", type: .bus, subtype: .regular),
    Line(name: "149", type: .bus, subtype: .regular),
    Line(name: "150", type: .bus, subtype: .regular),
    Line(name: "206", type: .bus, subtype: .night),
    Line(name: "240", type: .bus, subtype: .night),
    Line(name: "241", type: .bus, subtype: .night),
    Line(name: "243", type: .bus, subtype: .night),
    Line(name: "245", type: .bus, subtype: .night),
    Line(name: "246", type: .bus, subtype: .night),
    Line(name: "247", type: .bus, subtype: .night),
    Line(name: "248", type: .bus, subtype: .night),
    Line(name: "249", type: .bus, subtype: .night),
    Line(name: "250", type: .bus, subtype: .night),
    Line(name: "251", type: .bus, subtype: .night),
    Line(name: "253", type: .bus, subtype: .night),
    Line(name: "255", type: .bus, subtype: .night),
    Line(name: "257", type: .bus, subtype: .night),
    Line(name: "259", type: .bus, subtype: .night),
    Line(name: "319", type: .bus, subtype: .regular),
    Line(name: "325", type: .bus, subtype: .regular),
    Line(name: "331", type: .bus, subtype: .regular),
    Line(name: "602", type: .bus, subtype: .suburban),
    Line(name: "607", type: .bus, subtype: .suburban),
    Line(name: "609", type: .bus, subtype: .suburban),
    Line(name: "612", type: .bus, subtype: .suburban),
    Line(name: "116", type: .bus, subtype: .regular),
    Line(name: "128", type: .bus, subtype: .regular)
  ]

  internal static var bookmarks: [Bookmark] {
    let line0 = Line(name: "1", type: .tram, subtype: .regular)
    let line1 = Line(name: "4", type: .tram, subtype: .regular)
    let line2 = Line(name: "20", type: .tram, subtype: .regular)
    let line3 = Line(name: "A", type: .bus, subtype: .express)
    let line4 = Line(name: "D", type: .bus, subtype: .express)

    return [
      Bookmark(name: "All lines", lines: [line0, line1, line2, line3, line4]),
      Bookmark(name: "No lines", lines: []),
      Bookmark(name: "Tram only", lines: [line0, line1, line2]),
      Bookmark(name: "bus only", lines: [line3, line4]),
      Bookmark(name: "All lines 2", lines: [line0, line1, line2, line3, line4])
    ]
  }

  internal static var vehicles: [Vehicle] {
    let lines = [
      Line(name: "4", type: .tram, subtype: .regular),
      Line(name: "D", type: .bus, subtype: .express),
      Line(name: "246", type: .bus, subtype: .night),
      Line(name: "609", type: .bus, subtype: .suburban),
      Line(name: "20", type: .tram, subtype: .regular),
      Line(name: "??", type: .bus, subtype: .temporary),
      Line(name: "100", type: .bus, subtype: .regular),
      Line(name: "A", type: .bus, subtype: .express),
      Line(name: "602", type: .bus, subtype: .suburban),
      Line(name: "251", type: .bus, subtype: .night),
      Line(name: "!!", type: .bus, subtype: .temporary),
      Line(name: "126", type: .bus, subtype: .regular)
    ]

    func createVehicle(index: Int, line: Line) -> Vehicle {
      let centerLatitude = 51.109_524
      let centerLongitude = 17.032_564
      let radius = 0.015

      let angle = 360.0 * Double(index) / Double(lines.count)
      let latitude = centerLatitude + sin(rad(angle)) * radius
      let longitude = centerLongitude + cos(rad(angle)) * radius * 1.5

      return Vehicle(
        id: String(describing: index),
        line: line,
        latitude: latitude,
        longitude: longitude,
        angle: angle
      )
    }

    func rad(_ value: Double) -> Double {
      return value * Double.pi / 180.0
    }

    return lines
      .enumerated()
      .map(createVehicle(index:line:))
  }

  // swiftlint:disable:next function_body_length
  internal static func notifications(relativeTo date: Date) -> [Notification] {
    let date1970 = date.timeIntervalSince1970
    return [
      DummyData.createNotification(
        id: "1494314737261240325",
        date1970: date1970 - 0.0,
        body: "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      ),
      DummyData.createNotification(
        id: "1494313571211259904",
        date1970: date1970 - 278.0,
        body: "BRAK PRZEJAZDU - Bł. Czesława. Tramwaje linii 8, 9, 11, 17, 23 w kierunku pl. Bema skierowano przez Most Pokoju, ul. Wyszyńskiego."
      ),
      DummyData.createNotification(
        id: "1494295821222883335",
        date1970: date1970 - 4_510.0,
        body: "Most Osobowicki - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      ),
      DummyData.createNotification(
        id: "1494292552870203392",
        date1970: date1970 - 5_290.0,
        body: "⚠ Utrudnienia na godz 13:45 występują w następujących miejscach:\nℹ Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\n🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
      ),
      DummyData.createNotification(
        id: "1494283203447771136",
        date1970: date1970 - 7_519.0,
        body: "ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice"
      ),
      DummyData.createNotification(
        id: "1494283200549560320",
        date1970: date1970 - 7_519.0,
        body: "⚠ Utrudnienia na godz 13:10 występują w następujących miejscach:\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
      ),
      DummyData.createNotification(
        id: "1494277131177795589",
        date1970: date1970 - 8_966.0,
        body: "🚍 Autobusy linii 109 skierowano do Samotworu. ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
      ),
      DummyData.createNotification(
        id: "1494277128363421697",
        date1970: date1970 - 8_967.0,
        body: "⚠ AKTUALIZACJA 12:45\nUtrudnienia nadal występują w następujących miejscach:\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
      ),
      DummyData.createNotification(
        id: "1494274781142786048",
        date1970: date1970 - 9_527.0,
        body: "ul. Lipska i Las Osobowicki - ruch przywrócony. Autobusy wracają na swoje stałe trasy przejazdu.."
      ),
      DummyData.createNotification(
        id: "1494274653841506306",
        date1970: date1970 - 9_557.0,
        body: "ℹ ul. Jarnołtowska (drzewo na jezdni)🚍 Autobusy linii 109 skierowano do Samotworu."
      ),
      DummyData.createNotification(
        id: "1494274650888679432",
        date1970: date1970 - 9_558.0,
        body: "ℹ ul. Mościckiego (drzewo na jezdni)🚍 Autobusy linii 114, 125 skierowano przez Bardzką, Buforową, Konduktorską do Brochowa."
      ),
      DummyData.createNotification(
        id: "1494274648011333632",
        date1970: date1970 - 9_558.0,
        body: "⚠ Ze względu na silny wiatr utrudnienia występują w następujących miejscach:\n🚍 ul. Lipska i Las Osobowicki, autobusy wracają na swoje trasy.\n⚠ Utrudnienia nadal występują w następujących miejscach:"
      ),
      DummyData.createNotification(
        id: "1494273150472925190",
        date1970: date1970 - 9_916.0,
        body: "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu.."
      ),
      DummyData.createNotification(
        id: "1494268570850762758",
        date1970: date1970 - 11_007.0,
        body: "⚠ Brak przejazdu- Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\n🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
      ),
      DummyData.createNotification(
        id: "1494266909801467907",
        date1970: date1970 - 11_403.0,
        body: "⚠ Brak przejazdu- ul. Lipska (drzewo na jezdni).\n🚍 Autobusy linii 140 skrócono do Osobowic."
      ),
      DummyData.createNotification(
        id: "1494265201688039426",
        date1970: date1970 - 11_811.0,
        body: "⚠ Brak przejazdu- ul. Opolska (drzewo na torowisku).\n🚋Tramwaje linii 3 i 5 skierowano do Tarnogaju.\n🚍Kursują autobusy \"za tramwaj\" w relacji Galeria Dominikańska- Księże Małe."
      ),
      DummyData.createNotification(
        id: "1494260070439436288",
        date1970: date1970 - 13_034.0,
        body: "ul. Żmigrodzka - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      ),
      DummyData.createNotification(
        id: "1494249053164552194",
        date1970: date1970 - 15_661.0,
        body: "⚠ Brak przejazdu- ul. Żmigrodzka (kolizja z samochodem osobowym).\n🚋 Tramwaje linii 1, 7>POŚWIĘTNE skierowano przez pl. Staszica, ul. Reymonta, Bałtycką.\n🚍 Kursują autobusy \"za tramwaj\" w relacji Dworzec Nadodrze> Poświętne."
      ),
      DummyData.createNotification(
        id: "1494194063142268928",
        date1970: date1970 - 28_771.0,
        body: "al. Hallera - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      ),
      DummyData.createNotification(
        id: "1494192271192899584",
        date1970: date1970 - 39_199.0,
        body: "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      )
    ]
  }

  private static func createNotification(id: String,
                                         date1970: TimeInterval,
                                         body: String) -> Notification {
    return Notification(id: id,
                        url: "https://twitter.com/AlertMPK/status/\(id)",
                        authorName: "MPK Wrocław",
                        authorUsername: "AlertMPK",
                        date: Date(timeIntervalSince1970: date1970),
                        body: body)
  }
}

#endif
