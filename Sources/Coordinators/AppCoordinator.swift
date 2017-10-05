//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

  var window: UIWindow
  var childCoordinators: [Coordinator] = []

  fileprivate var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    self.window.rootViewController = MainViewController(delegate: self)
    self.window.makeKeyAndVisible()
  }
}

extension AppCoordinator: MainViewControllerDelegate {

  func mainViewControllerDidAppear(_ viewController: MainViewController) {
    let hasSeenTutorial = Managers.app.hasSeenTutorial
    guard !hasSeenTutorial else { return }

    let coordinator = FirstUseTutorialCoordinator(parent: viewController, delegate: self)
    coordinator.start()
    self.addChildCoordinator(coordinator)
  }

  func mainViewControllerDidTapSearchButton(_ viewController: MainViewController) {
    let panel = SearchViewController()
    panel.delegate = viewController
    self.presentCardPanel(panel, in: viewController)
  }

  func mainViewControllerDidTapTapBookmarksButton(_ viewController: MainViewController) {
    let panel = BookmarksViewController()
    panel.delegate = viewController
    self.presentCardPanel(panel, in: viewController)
  }

  func mainViewControllerDidTapConfigurationButton(_ viewController: MainViewController) {
    let controller = ConfigurationViewController()
    self.presentCardPanel(controller, in: viewController)
  }

  private func presentCardPanel<TCardPanel>(_ cardPanel: TCardPanel, in viewController: UIViewController)
    where TCardPanel: UIViewController, TCardPanel: CardPanelPresentable
  {
    self.cardPanelTransitionDelegate = CardPanelTransitionDelegate(for: cardPanel)
    cardPanel.modalPresentationStyle = .custom
    cardPanel.transitioningDelegate  = self.cardPanelTransitionDelegate!
    viewController.present(cardPanel, animated: true, completion: nil)
  }
}

extension AppCoordinator: FirstUseTutorialCoordinatorDelegate {
  func firstUseTutorialCoordinatorDidClose(_ coordinator: FirstUseTutorialCoordinator) {
    Managers.app.hasSeenTutorial = true
    Managers.location.requestAuthorization()
    self.removeChildCoordinator(coordinator)
    Swift.print("\(URL(fileURLWithPath: #file).lastPathComponent) \(#function) \(#line): \(0)")
  }
}
