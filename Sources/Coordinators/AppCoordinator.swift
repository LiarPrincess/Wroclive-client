//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

  let window: UIWindow
  var childCoordinators: [Coordinator] = []

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    self.window.rootViewController = MainViewController(delegate: self)
    self.window.makeKeyAndVisible()
  }
}

extension AppCoordinator: MainViewControllerDelegate,
                          SearchCoordinatorDelegate,
                          BookmarksCoordinatorDelegate,
                          ConfigurationCoordinatorDelegate {

  // MARK: - Main

  func mainViewControllerDidAppear(_ viewController: MainViewController) {
    let authorization = Managers.location.authorization

    if authorization == .notDetermined {
      let delay = AppInfo.Timings.locationAuthorizationPromptDelay
      self.requestLocationAuthorization(after: delay)
    }
  }

  private func requestLocationAuthorization(after: TimeInterval) {
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
      Managers.location.requestAuthorization()
    }
  }

  // MARK: - Search

  func mainViewControllerDidTapSearchButton(_ viewController: MainViewController) {
    let coordinator = SearchCoordinator(parent: viewController, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func coordinatorDidClose(_ coordinator: SearchCoordinator) {
    self.removeChildCoordinator(coordinator)
  }

  // MARK: - Bookmarks

  func mainViewControllerDidTapBookmarksButton(_ viewController: MainViewController) {
    let coordinator = BookmarksCoordinator(parent: viewController, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func coordinatorDidClose(_ coordinator: BookmarksCoordinator) {
    self.removeChildCoordinator(coordinator)
  }

  // MARK: - Configuration

  func mainViewControllerDidTapConfigurationButton(_ viewController: MainViewController) {
    let coordinator = ConfigurationCoordinator(parent: viewController, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func coordinatorDidClose(_ coordinator: ConfigurationCoordinator) {
    self.removeChildCoordinator(coordinator)
  }
}
