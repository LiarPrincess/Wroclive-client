//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ColorSelectionCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: ColorSelectionCoordinator)
}

class ColorSelectionCoordinator: PushCoordinator {
  var childCoordinators: [Coordinator] = []

  var pushTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: ColorSelectionCoordinatorDelegate?

  init(parent: UIViewController, delegate: ColorSelectionCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let child = ColorSelectionViewController(delegate: self)
    self.presentPush(child, in: parent)
  }
}

extension ColorSelectionCoordinator: ColorSelectionViewControllerDelegate {

  // MARK: - Close

  func colorSelectionViewControllerDidClose(_ viewController: ColorSelectionViewController) {
    self.delegate?.coordinatorDidClose(self)
  }

  func colorSelectionViewControllerDidTapCloseButton(_ viewController: ColorSelectionViewController) {
    viewController.dismiss(animated: true, completion: nil)
  }
}
