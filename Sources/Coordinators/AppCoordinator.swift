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
                          TutorialViewControllerDelegate,
                          SearchViewControllerDelegate,
                          BookmarksViewControllerDelegate,
                          ConfigurationCoordinatorDelegate
{

  // MARK: - Tutorial

  func mainViewControllerDidAppear(_ viewController: MainViewController) {
    let hasSeenTutorial = Managers.app.hasSeenTutorial
    guard !hasSeenTutorial else { return }

    let controller = TutorialViewController(mode: .firstUse, delegate: self)
    viewController.present(controller, animated: true, completion: nil)
  }

  func tutorialViewControllerDidTapCloseButton(_ viewController: TutorialViewController) {
    viewController.dismiss(animated: true, completion: nil)
    Managers.app.hasSeenTutorial = true
    Managers.location.requestAuthorization()
  }

  // MARK: - Search

  func mainViewControllerDidTapSearchButton(_ viewController: MainViewController) {
    let panel = SearchViewController(delegate: self)
    self.presentCardPanel(panel, in: viewController)
  }

  func searchViewController(_ controller: SearchViewController, didSelect lines: [Line]) {
    Managers.tracking.start(lines)
  }

  // MARK: - Bookmarks

  func mainViewControllerDidTapBookmarksButton(_ viewController: MainViewController) {
    let panel = BookmarksViewController(delegate: self)
    self.presentCardPanel(panel, in: viewController)
  }

  func bookmarksViewController(_ controller: BookmarksViewController, didSelect bookmark: Bookmark) {
    Managers.tracking.start(bookmark.lines)
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
