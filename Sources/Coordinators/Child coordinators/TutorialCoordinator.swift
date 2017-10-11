//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol TutorialCoordinatorDelegate: class {
  func tutorialCoordinatorDidClose(_ coordinator: TutorialCoordinator)
}

class TutorialCoordinator: PushCoordinator {

  let mode:     TutorialViewControllerMode
  let managers: DependencyManager

  var childCoordinators: [Coordinator] = []

  var pushTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: TutorialCoordinatorDelegate?

  init(parent: UIViewController, mode: TutorialViewControllerMode, managers: DependencyManager, delegate: TutorialCoordinatorDelegate) {
    self.mode     = mode
    self.parent   = parent
    self.managers = managers
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let controller = TutorialViewController(mode: self.mode, managers: managers, delegate: self)

    switch self.mode {
    case .firstUse: parent.present(controller, animated: true, completion: nil)
    case .default:  self.presentPush(controller, in: parent)
    }
  }
}

// MARK: - TutorialViewControllerDelegate

extension TutorialCoordinator: TutorialViewControllerDelegate {
  func tutorialViewControllerDidTapCloseButton(_ viewController: TutorialViewController) {
    viewController.dismiss(animated: true, completion: nil)
    self.delegate?.tutorialCoordinatorDidClose(self)
  }
}
