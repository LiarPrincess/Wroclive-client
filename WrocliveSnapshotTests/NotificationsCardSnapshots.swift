// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
import ReSwift
import WrocliveTestsShared
@testable import WrocliveFramework

// swiftlint:disable force_unwrapping
// swiftlint:disable implicitly_unwrapped_optional

private let second = 1.0
private let minute = 60.0 * second
private let hour = 60.0 * minute
private let day = 24.0 * hour

class NotificationsCardSnapshots: XCTestCase, ReduxTestCase, EnvironmentTestCase, SnapshotTestCase {

  typealias Notification = WrocliveFramework.Notification

  var store: Store<AppState>!
  var dispatchedActions: [Action]!
  var environment: Environment!

  let now = Date(iso8601: "2022-01-01T00:00:00.000Z")!

  override func setUp() {
    super.setUp()
    self.setUpRedux()
    self.setUpEnvironment()
  }

  // MARK: - Tests

  func test_loading() {
    self.onAllDevicesInAllLocales { assertSnapshot in
      let viewModel = self.createViewModel()
      let view = NotificationsCard(viewModel: viewModel)
      self.setNotifications(state: .inProgress)
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_notifications() {
    self.onAllDevicesInAllLocales { assertSnapshot in
      let viewModel = self.createViewModel()
      let view = NotificationsCard(viewModel: viewModel)
      self.setNotifications(state: .data(self.notifications))
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_noNotifications() {
    self.onAllDevicesInAllLocales { assertSnapshot in
      let viewModel = self.createViewModel()
      let view = NotificationsCard(viewModel: viewModel)
      self.setNotifications(state: .data([]))
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_dark_notifications() {
    self.inDarkMode { assertSnapshot in
      let viewModel = self.createViewModel()
      let view = NotificationsCard(viewModel: viewModel)

      self.setNotifications(state: .inProgress)
      assertSnapshot(view, .errorOnThisLine())

      self.setNotifications(state: .data(self.notifications))
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  func test_dark_noNotifications() {
    self.inDarkMode { assertSnapshot in
      let viewModel = self.createViewModel()
      let view = NotificationsCard(viewModel: viewModel)

      self.setNotifications(state: .inProgress)
      assertSnapshot(view, .errorOnThisLine())

      self.setNotifications(state: .data([]))
      assertSnapshot(view, .errorOnThisLine())
    }
  }

  // MARK: - Helpers

  private func setNotifications(state: AppState.ApiResponseState<[Notification]>) {
    self.setState { $0.getNotificationsResponse = state }
  }

  private func createViewModel() -> NotificationsCardViewModel {
    return NotificationsCardViewModel(store: self.store,
                                      delegate: nil,
                                      date: self.now)
  }

  private lazy var notifications: [Notification] = [
    self.createNotification(
      id: "1",
      age: -2 * minute, // Future
      body: "Bł. Czesława - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
    ),
    self.createNotification(
      id: "2",
      age: 5 * second, // Now
      body: "BRAK PRZEJAZDU - Bł. Czesława. Tramwaje linii 8, 9, 11, 17, 23 w kierunku pl. Bema skierowano przez Most Pokoju, ul. Wyszyńskiego."
    ),
    self.createNotification(
      id: "3",
      age: 3 * minute + 11 * second,
      body: "Most Osobowicki - ruch przywrócony. Tramwaje wracają na swoje stałe trasy przejazdu."
    ),
    self.createNotification(
      id: "4",
      age: 42 * minute + 13 * second,
      body: "⚠ Utrudnienia na godz 13:45 występują w następujących miejscach:\nℹ Most Osobowicki (połamany pantograf).\n🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego.\n🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice."
    ),
    self.createNotification(
      id: "5",
      age: 3 * hour + 11 * minute,
      body: "ℹ Most Osobowicki (połamany pantograf). 🚋 Tramwaje linii 15, 70, 74 skierowano przez Dworzec Nadodrze, ul. Trzebnicką do Poświętnego. 🚍Kursują autobusy \"za tramwaj\" w relacji pl. Staszica- Osobowice"
    ),
    self.createNotification(
      id: "6",
      age: 7 * day + 3 * minute + 42 * second,
      body: "⚠ Utrudnienia na godz 13:10 występują w następujących miejscach:\nℹ ul. Pilczycka/Modra (drzewo na jezdni).\n🚍 Autobusy linii 101, 102, 103 w kierunku KWISKIEJ skierowano przez ul. Kozanowską."
    )
  ]

  private func createNotification(id: String,
                                  age: TimeInterval,
                                  body: String) -> Notification {
    let date = Date(timeInterval: -age, since: self.now)
    return Notification(id: id,
                        url: "https://twitter.com/AlertMPK/status/\(id)",
                        authorName: "MPK Wrocław",
                        authorUsername: "AlertMPK",
                        date: date,
                        body: body)
  }
}
