//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol FirstUseTutorialCoordinatorDelegate: class {
  func firstUseTutorialCoordinatorDidClose(_ coordinator: FirstUseTutorialCoordinator)
}

class FirstUseTutorialCoordinator: Coordinator {
  var childCoordinators: [Coordinator] = []

  weak var parent:   UIViewController?
  weak var delegate: FirstUseTutorialCoordinatorDelegate?

  init(parent: UIViewController, delegate: FirstUseTutorialCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let controller = TutorialViewController(mode: .firstUse, delegate: self)
    parent.present(controller, animated: true, completion: nil)
  }
}

// MARK: - TutorialViewControllerDelegate

extension FirstUseTutorialCoordinator: TutorialViewControllerDelegate {
  func tutorialViewControllerDidTapCloseButton(_ viewController: TutorialViewController) {
    viewController.dismiss(animated: true, completion: nil)
    self.delegate?.firstUseTutorialCoordinatorDidClose(self)
  }
}
