//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ConfigurationCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: ConfigurationCoordinator)
}

class ConfigurationCoordinator: CardPanelCoordinator, PushCoordinator {
  var childCoordinators: [Coordinator] = []

  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
  var pushTransitionDelegate:      UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: ConfigurationCoordinatorDelegate?

  init(parent: UIViewController, delegate: ConfigurationCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let controller = ConfigurationViewController(delegate: self)
    self.presentCardPanel(controller, in: parent)
  }
}

extension ConfigurationCoordinator: ConfigurationViewControllerDelegate,
                                    TutorialViewControllerDelegate
{

  // MARK: - Close

  func configurationViewControllerDidClose(_ viewController: ConfigurationViewController) {
    self.delegate?.coordinatorDidClose(self)
  }

  // MARK: - Theme

  func configurationViewControllerDidTapThemeButton(_ viewController: ConfigurationViewController) {
    let child = ColorSelectionViewController()
    self.presentPush(child, in: viewController)
  }

  // MARK: - Tutorial

  func configurationViewControllerDidTapTutorialButton(_ viewController: ConfigurationViewController) {
    let child = TutorialViewController(mode: .default, delegate: self)
    self.presentPush(child, in: viewController)
  }

  func tutorialViewControllerDidTapCloseButton(_ viewController: TutorialViewController) {
    viewController.dismiss(animated: true, completion: nil)
  }
}
