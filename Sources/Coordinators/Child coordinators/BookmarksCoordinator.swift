//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol BookmarksCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: BookmarksCoordinator)
}

class BookmarksCoordinator: CardPanelCoordinator {
  var childCoordinators: [Coordinator] = []

  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: BookmarksCoordinatorDelegate?

  init(parent: UIViewController, delegate: BookmarksCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let panel = BookmarksViewController(delegate: self)
    self.presentCardPanel(panel, in: parent)
  }
}

extension BookmarksCoordinator: BookmarksViewControllerDelegate {

  func bookmarksViewController(_ viewController: BookmarksViewController, didSelect bookmark: Bookmark) {
    Managers.tracking.start(bookmark.lines)
    viewController.dismiss(animated: true, completion: nil)
  }

  func bookmarksViewControllerDidClose(_ viewController: BookmarksViewController) {
    self.delegate?.coordinatorDidClose(self)
  }
}
