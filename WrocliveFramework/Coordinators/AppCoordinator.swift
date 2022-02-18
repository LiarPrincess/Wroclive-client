// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import os.log
import UIKit
import ReSwift

public final class AppCoordinator: MainViewModelDelegate {

  public let window: UIWindow
  public let store: Store<AppState>
  public let environment: Environment

  public private(set) var mainViewController: MainViewController?
  private var childCoordinator: CardCoordinator?

  public init(window: UIWindow, store: Store<AppState>, environment: Environment) {
    self.store = store
    self.window = window
    self.environment = environment
  }

  public func start() {
    let viewModel = MainViewModel(store: self.store,
                                  environment: self.environment,
                                  delegate: self)
    self.mainViewController = MainViewController(viewModel: viewModel)

    self.window.rootViewController = self.mainViewController
    self.window.makeKeyAndVisible()
  }

  // MARK: - Search

  public func openSearchCard() {
    guard let mainViewController = self.mainViewController else {
      fatalError("AppCoordinator has to be started first")
    }

    let coordinator = SearchCardCoordinator(parent: mainViewController,
                                            store: self.store,
                                            environment: self.environment)
    self.showCard(coordinator: coordinator, animated: true)
  }

  // MARK: - Bookmarks

  public func openBookmarksCard() {
    guard let mainViewController = self.mainViewController else {
      fatalError("AppCoordinator has to be started first")
    }

    let coordinator = BookmarksCardCoordinator(parent: mainViewController,
                                               store: self.store,
                                               environment: self.environment)
    self.showCard(coordinator: coordinator, animated: true)
  }

  // MARK: - Notificaions

  public func openNotificationsCard() {
    guard let mainViewController = self.mainViewController else {
      fatalError("AppCoordinator has to be started first")
    }

    let coordinator = NotificationsCardCoordinator(parent: mainViewController,
                                                   store: self.store,
                                                   environment: self.environment)
    self.showCard(coordinator: coordinator, animated: true)
  }

  // MARK: - Settings

  public func openSettingsCard() {
    guard let mainViewController = self.mainViewController else {
      fatalError("AppCoordinator has to be started first")
    }

    let coordinator = SettingsCardCoordinator(parent: mainViewController,
                                              store: self.store,
                                              environment: self.environment)
    self.showCard(coordinator: coordinator, animated: true)
  }

  private func showCard<C: CardCoordinator>(coordinator: C, animated: Bool) {
    assert(self.childCoordinator == nil)

    self.childCoordinator = coordinator
    coordinator.start(animated: animated).done { [weak self] in
      self?.childCoordinator = nil
    }
  }

  // MARK: - Settings app

  public func openSettingsApp() {
    let urlString = UIApplication.openSettingsURLString

    if let url = URL(string: urlString) {
      UIApplication.shared.open(url)
    } else {
      os_log(
        "Unable to upen settings app from: %{public}@",
        log: self.environment.log.app,
        type: .error,
        urlString
      )
    }
  }
}
