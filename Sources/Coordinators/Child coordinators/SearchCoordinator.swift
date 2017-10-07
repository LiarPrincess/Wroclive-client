//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol SearchCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: SearchCoordinator)
}

class SearchCoordinator: CardPanelCoordinator {
  let managers:          DependencyManager

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: SearchCoordinatorDelegate?

  init(parent: UIViewController, managers: DependencyManager, delegate: SearchCoordinatorDelegate) {
    self.parent   = parent
    self.managers = managers
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let panel = SearchViewController(managers: self.managers, delegate: self)
    self.presentCardPanel(panel, in: parent)
  }
}

extension SearchCoordinator: SearchViewControllerDelegate {

  func searchViewController(_ viewController: SearchViewController, didSelect lines: [Line]) {
    Managers.tracking.start(lines)
    viewController.dismiss(animated: true, completion: nil)
  }

  func searchViewControllerDidClose(_ viewController: SearchViewController) {
    self.delegate?.coordinatorDidClose(self)
  }
}
