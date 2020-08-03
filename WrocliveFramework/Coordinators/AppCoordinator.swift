// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift

public final class AppCoordinator: Coordinator {

  public let window: UIWindow
  public let store:  Store<AppState>
  public let environment: Environment

  private var mainViewController: MainViewController?

  // We will temporary leak (meaning: retain when no longer needed) last coordinator,
  // but it is not that much of a memory and it is way easier to handle in code.
  // Leak ends (it is dealocated) when user starts new childCoordinator.
  private var childCoordinator: Coordinator?

  public init(window: UIWindow, store: Store<AppState>, environment: Environment) {
    self.store = store
    self.window = window
    self.environment = environment
  }

  public func start() {
    let viewModel = MainViewModel(store: self.store,
                                  environment: self.environment)

    self.mainViewController = MainViewController(viewModel: viewModel,
                                                 environment: self.environment)

    self.window.rootViewController = self.mainViewController
    self.window.makeKeyAndVisible()
  }

/*
  private func openSearchCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = SearchCardCoordinator(mainViewController, self.store)
    self.childCoordinator!.start()
  }

  private func openBookmarksCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = BookmarksCardCoordinator(mainViewController, self.store)
    self.childCoordinator!.start()
  }

  private func openSettingsCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = SettingsCardCoordinator(mainViewController)
    self.childCoordinator!.start()
  }
*/
}
