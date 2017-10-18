//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ConfigurationCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: ConfigurationCoordinator)
}

class ConfigurationCoordinator: CardPanelCoordinator {

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: ConfigurationCoordinatorDelegate?

  init(parent: UIViewController, delegate: ConfigurationCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let panel = ConfigurationViewController(delegate: self)
    self.presentCardPanel(panel, in: parent, animated: true)
  }
}

extension ConfigurationCoordinator: ConfigurationViewControllerDelegate,
                                    ColorSelectionCoordinatorDelegate,
                                    TutorialCoordinatorDelegate {

  // MARK: - Close

  func configurationViewControllerDidClose(_ viewController: ConfigurationViewController) {
    self.delegate?.coordinatorDidClose(self)
  }

  // MARK: - Color selection

  func configurationViewControllerDidTapColorSelectionButton(_ viewController: ConfigurationViewController) {
    let coordinator = ColorSelectionCoordinator(parent: viewController, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func coordinatorDidClose(_ coordinator: ColorSelectionCoordinator) {
    self.removeChildCoordinator(coordinator)
  }

  // MARK: - Tutorial

  func configurationViewControllerDidTapTutorialButton(_ viewController: ConfigurationViewController) {
    let coordinator = TutorialCoordinator(parent: viewController, mode: .default, delegate: self)
    self.childCoordinators.append(coordinator)
    coordinator.start()
  }

  func tutorialCoordinatorDidClose(_ coordinator: TutorialCoordinator) {
    self.removeChildCoordinator(coordinator)
  }
}
