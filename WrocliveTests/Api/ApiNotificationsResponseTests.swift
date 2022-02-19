// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import Foundation
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length
// swiftlint:disable closure_body_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

class ApiNotificationsResponseTests: XCTestCase, ApiTestCase {

  func test_single() {
    let response = """
{
  "timestamp": "2022-02-18T11:04:18.660Z",
  "data": [
    {
      "id": "1494314737261240325",
      "url": "https://twitter.com/AlertMPK/status/1494314737261240325",
      "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
      "date": "2022-02-17T14:16:11.000Z",
      "body": "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
    }
  ]
}
"""

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getNotifications().done { notifications in
      XCTAssertResponse(notifications, [
        .init(
          id: "1494314737261240325",
          url: "https://twitter.com/AlertMPK/status/1494314737261240325",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T14:16:11.000Z",
          body: "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        )
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_partial_success() {
    let response = """
  {
    "timestamp": "2022-02-18T11:04:18.660Z",
    "data": [
      {
        "id": "1494314737261240325",
        "url": "https://twitter.com/AlertMPK/status/1494314737261240325",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T14:16:11.000Z",
        "body": "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      },
      {
        "id": "1494313571211259904",
        "url": "https://twitter.com/AlertMPK/status/1494313571211259904",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "123",
        "body": "BRAK PRZEJAZDU - Bł. Czesława. Tramwaje linii 8, 9, 11, 17, 23 w kierunku pl. Bema skierowano przez Most Pokoju, ul. Wyszyńskiego."
      }
    ]
  }
  """

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getNotifications().done { notifications in
      XCTAssertResponse(notifications, [
        .init(
          id: "1494314737261240325",
          url: "https://twitter.com/AlertMPK/status/1494314737261240325",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T14:16:11.000Z",
          body: "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        )
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }

  func test_full() {
    let response = """
  {
    "timestamp": "2022-02-18T11:04:18.660Z",
    "data": [
      {
        "id": "1494314737261240325",
        "url": "https://twitter.com/AlertMPK/status/1494314737261240325",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T14:16:11.000Z",
        "body": "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      },
      {
        "id": "1494313571211259904",
        "url": "https://twitter.com/AlertMPK/status/1494313571211259904",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T14:11:33.000Z",
        "body": "BRAK PRZEJAZDU - Bł. Czesława. Tramwaje linii 8, 9, 11, 17, 23 w kierunku pl. Bema skierowano przez Most Pokoju, ul. Wyszyńskiego."
      },
      {
        "id": "1494295821222883335",
        "url": "https://twitter.com/AlertMPK/status/1494295821222883335",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T13:01:01.000Z",
        "body": "Most Osobowicki - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      },
      {
        "id": "1494292552870203392",
        "url": "https://twitter.com/AlertMPK/status/1494292552870203392",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T12:48:01.000Z",
        "body": "⚠ Utrudnienia na godz 13:45 występują w następujących miejscach:\\nℹ Most Osobowicki (połamany pantograf).\\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\\n🚍Kursują autobusy \\"za tramwaj\\" w relacji pl. Staszica- Osobowice."
      },
      {
        "id": "1494283203447771136",
        "url": "https://twitter.com/AlertMPK/status/1494283203447771136",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T12:10:52.000Z",
        "body": "ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \\"za tramwaj\\" w relacji pl. Staszica- Osobowice"
      },
      {
        "id": "1494283200549560320",
        "url": "https://twitter.com/AlertMPK/status/1494283200549560320",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T12:10:52.000Z",
        "body": "⚠ Utrudnienia na godz 13:10 występują w następujących miejscach:\\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
      },
      {
        "id": "1494277131177795589",
        "url": "https://twitter.com/AlertMPK/status/1494277131177795589",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:46:45.000Z",
        "body": "🚍 Autobusy linii 109 skierowano do Samotworu. ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \\"za tramwaj\\" w relacji pl. Staszica- Osobowice."
      },
      {
        "id": "1494277128363421697",
        "url": "https://twitter.com/AlertMPK/status/1494277128363421697",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:46:44.000Z",
        "body": "⚠ AKTUALIZACJA 12:45\\nUtrudnienia nadal występują w następujących miejscach:\\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
      },
      {
        "id": "1494274781142786048",
        "url": "https://twitter.com/AlertMPK/status/1494274781142786048",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:37:24.000Z",
        "body": "ul. Lipska i Las Osobowicki - ruch przywrócony. Autobusy wracają na swoje stałe trasy przejazdu.."
      },
      {
        "id": "1494274653841506306",
        "url": "https://twitter.com/AlertMPK/status/1494274653841506306",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:36:54.000Z",
        "body": "ℹ ul. Jarnołtowska (drzewo na jezdni)🚍 Autobusy linii 109 skierowano do Samotworu."
      },
      {
        "id": "1494274650888679432",
        "url": "https://twitter.com/AlertMPK/status/1494274650888679432",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:36:53.000Z",
        "body": "ℹ ul. Mościckiego (drzewo na jezdni)🚍 Autobusy linii 114, 125 skierowano przez Bardzką, Buforową, Konduktorską do Brochowa."
      },
      {
        "id": "1494274648011333632",
        "url": "https://twitter.com/AlertMPK/status/1494274648011333632",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:36:53.000Z",
        "body": "⚠ Ze względu na silny wiatr utrudnienia występują w następujących miejscach:\\n🚍 ul. Lipska i Las Osobowicki, autobusy wracają na swoje trasy.\\n⚠ Utrudnienia nadal występują w następujących miejscach:"
      },
      {
        "id": "1494273150472925190",
        "url": "https://twitter.com/AlertMPK/status/1494273150472925190",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:30:55.000Z",
        "body": "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu.."
      },
      {
        "id": "1494268570850762758",
        "url": "https://twitter.com/AlertMPK/status/1494268570850762758",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:12:44.000Z",
        "body": "⚠ Brak przejazdu- Most Osobowicki (połamany pantograf).\\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\\n🚍Kursują autobusy \\"za tramwaj\\" w relacji pl. Staszica- Osobowice."
      },
      {
        "id": "1494266909801467907",
        "url": "https://twitter.com/AlertMPK/status/1494266909801467907",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T11:06:08.000Z",
        "body": "⚠ Brak przejazdu- ul. Lipska (drzewo na jezdni).\\n🚍 Autobusy linii 140 skrócono do Osobowic."
      },
      {
        "id": "1494265201688039426",
        "url": "https://twitter.com/AlertMPK/status/1494265201688039426",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T10:59:20.000Z",
        "body": "⚠ Brak przejazdu- ul. Opolska (drzewo na torowisku).\\n🚋Tramwaje linii 3 i 5 skierowano do Tarnogaju.\\n🚍Kursują autobusy \\"za tramwaj\\" w relacji Galeria Dominikańska- Księże Małe."
      },
      {
        "id": "1494260070439436288",
        "url": "https://twitter.com/AlertMPK/status/1494260070439436288",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T10:38:57.000Z",
        "body": "ul. Żmigrodzka - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      },
      {
        "id": "1494249053164552194",
        "url": "https://twitter.com/AlertMPK/status/1494249053164552194",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T09:55:10.000Z",
        "body": "⚠ Brak przejazdu- ul. Żmigrodzka (kolizja z samochodem osobowym).\\n🚋 Tramwaje linii 1, 7>POŚWIĘTNE skierowano przez pl. Staszica, ul. Reymonta, Bałtycką.\\n🚍 Kursują autobusy \\"za tramwaj\\" w relacji Dworzec Nadodrze> Poświętne."
      },
      {
        "id": "1494194063142268928",
        "url": "https://twitter.com/AlertMPK/status/1494194063142268928",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T06:16:40.000Z",
        "body": "al. Hallera - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      },
      {
        "id": "1494192271192899584",
        "url": "https://twitter.com/AlertMPK/status/1494192271192899584",
        "author": { "name": "MPK Wrocław", "username": "AlertMPK" },
        "date": "2022-02-17T06:09:32.000Z",
        "body": "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
      }
    ]
  }
  """

    let api = self.createApi(baseUrl: "API_URL") { _ in
      let data = response.data(using: .utf8)!
      return (HTTPURLResponse(), data)
    }

    let expectation = XCTestExpectation(description: "response")
    _ = api.getNotifications().done { notifications in

      XCTAssertResponse(notifications, [
        .init(
          id: "1494314737261240325",
          url: "https://twitter.com/AlertMPK/status/1494314737261240325",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T14:16:11.000Z",
          body: "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        ),
        .init(
          id: "1494313571211259904",
          url: "https://twitter.com/AlertMPK/status/1494313571211259904",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T14:11:33.000Z",
          body: "BRAK PRZEJAZDU - Bł. Czesława. Tramwaje linii 8, 9, 11, 17, 23 w kierunku pl. Bema skierowano przez Most Pokoju, ul. Wyszyńskiego."
        ),
        .init(
          id: "1494295821222883335",
          url: "https://twitter.com/AlertMPK/status/1494295821222883335",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T13:01:01.000Z",
          body: "Most Osobowicki - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        ),
        .init(
          id: "1494292552870203392",
          url: "https://twitter.com/AlertMPK/status/1494292552870203392",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T12:48:01.000Z",
          body: "⚠ Utrudnienia na godz 13:45 występują w następujących miejscach:\nℹ Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\n🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
        ),
        .init(
          id: "1494283203447771136",
          url: "https://twitter.com/AlertMPK/status/1494283203447771136",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T12:10:52.000Z",
          body: "ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice"
        ),
        .init(
          id: "1494283200549560320",
          url: "https://twitter.com/AlertMPK/status/1494283200549560320",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T12:10:52.000Z",
          body: "⚠ Utrudnienia na godz 13:10 występują w następujących miejscach:\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
        ),
        .init(
          id: "1494277131177795589",
          url: "https://twitter.com/AlertMPK/status/1494277131177795589",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:46:45.000Z",
          body: "🚍 Autobusy linii 109 skierowano do Samotworu. ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
        ),
        .init(
          id: "1494277128363421697",
          url: "https://twitter.com/AlertMPK/status/1494277128363421697",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:46:44.000Z",
          body: "⚠ AKTUALIZACJA 12:45\nUtrudnienia nadal występują w następujących miejscach:\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
        ),
        .init(
          id: "1494274781142786048",
          url: "https://twitter.com/AlertMPK/status/1494274781142786048",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:37:24.000Z",
          body: "ul. Lipska i Las Osobowicki - ruch przywrócony. Autobusy wracają na swoje stałe trasy przejazdu.."
        ),
        .init(
          id: "1494274653841506306",
          url: "https://twitter.com/AlertMPK/status/1494274653841506306",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:36:54.000Z",
          body: "ℹ ul. Jarnołtowska (drzewo na jezdni)🚍 Autobusy linii 109 skierowano do Samotworu."
        ),
        .init(
          id: "1494274650888679432",
          url: "https://twitter.com/AlertMPK/status/1494274650888679432",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:36:53.000Z",
          body: "ℹ ul. Mościckiego (drzewo na jezdni)🚍 Autobusy linii 114, 125 skierowano przez Bardzką, Buforową, Konduktorską do Brochowa."
        ),
        .init(
          id: "1494274648011333632",
          url: "https://twitter.com/AlertMPK/status/1494274648011333632",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:36:53.000Z",
          body: "⚠ Ze względu na silny wiatr utrudnienia występują w następujących miejscach:\n🚍 ul. Lipska i Las Osobowicki, autobusy wracają na swoje trasy.\n⚠ Utrudnienia nadal występują w następujących miejscach:"
        ),
        .init(
          id: "1494273150472925190",
          url: "https://twitter.com/AlertMPK/status/1494273150472925190",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:30:55.000Z",
          body: "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu.."
        ),
        .init(
          id: "1494268570850762758",
          url: "https://twitter.com/AlertMPK/status/1494268570850762758",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:12:44.000Z",
          body: "⚠ Brak przejazdu- Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\n🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
        ),
        .init(
          id: "1494266909801467907",
          url: "https://twitter.com/AlertMPK/status/1494266909801467907",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T11:06:08.000Z",
          body: "⚠ Brak przejazdu- ul. Lipska (drzewo na jezdni).\n🚍 Autobusy linii 140 skrócono do Osobowic."
        ),
        .init(
          id: "1494265201688039426",
          url: "https://twitter.com/AlertMPK/status/1494265201688039426",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T10:59:20.000Z",
          body: "⚠ Brak przejazdu- ul. Opolska (drzewo na torowisku).\n🚋Tramwaje linii 3 i 5 skierowano do Tarnogaju.\n🚍Kursują autobusy \"za tramwaj\" w relacji Galeria Dominikańska- Księże Małe."
        ),
        .init(
          id: "1494260070439436288",
          url: "https://twitter.com/AlertMPK/status/1494260070439436288",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T10:38:57.000Z",
          body: "ul. Żmigrodzka - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        ),
        .init(
          id: "1494249053164552194",
          url: "https://twitter.com/AlertMPK/status/1494249053164552194",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T09:55:10.000Z",
          body: "⚠ Brak przejazdu- ul. Żmigrodzka (kolizja z samochodem osobowym).\n🚋 Tramwaje linii 1, 7>POŚWIĘTNE skierowano przez pl. Staszica, ul. Reymonta, Bałtycką.\n🚍 Kursują autobusy \"za tramwaj\" w relacji Dworzec Nadodrze> Poświętne."
        ),
        .init(
          id: "1494194063142268928",
          url: "https://twitter.com/AlertMPK/status/1494194063142268928",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T06:16:40.000Z",
          body: "al. Hallera - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        ),
        .init(
          id: "1494192271192899584",
          url: "https://twitter.com/AlertMPK/status/1494192271192899584",
          authorName: "MPK Wrocław",
          authorUsername: "AlertMPK",
          date: "2022-02-17T06:09:32.000Z",
          body: "ul. Opolska - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
        )
      ])

      expectation.fulfill()
    }

    self.wait(for: [expectation], timeout: 1.0)
  }
}
