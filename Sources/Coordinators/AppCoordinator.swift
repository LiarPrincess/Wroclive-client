//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppCoordinator: CardPanelCoordinator {

  var window: UIWindow
  var childCoordinators: [Coordinator] = []

  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    self.window.rootViewController = MainViewController(delegate: self)
    self.window.makeKeyAndVisible()
  }
}

extension AppCoordinator: MainViewControllerDelegate,
                          TutorialCoordinatorDelegate,
                          SearchCoordinatorDelegate,
                          BookmarksCoordinatorDelegate,
                          ConfigurationCoordinatorDelegate
{

  // MARK: - Tutorial

  func mainViewControllerDidAppear(_ viewController: MainViewController) {
    let hasSeenTutorial = Managers.app.hasSeenTutorial
    guard !hasSeenTutorial else { return }

    let coordinator = TutorialCoordinator(parent: viewController, mode: .firstUse, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func tutorialCoordinatorDidClose(_ coordinator: TutorialCoordinator) {
    self.removeChildCoordinator(coordinator)

    if coordinator.mode == .firstUse {
      Managers.app.hasSeenTutorial = true
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
