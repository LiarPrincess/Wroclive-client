//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol BookmarksCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: BookmarksCoordinator)
}

class BookmarksCoordinator: CardPanelCoordinator {

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: BookmarksCoordinatorDelegate?

  private let disposeBag = DisposeBag()

  init(parent: UIViewController, delegate: BookmarksCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let viewModel      = BookmarksViewModel()
    let viewController = BookmarksViewController(viewModel)
    self.bindOnClosed(viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

  private func bindOnClosed(_ viewController: BookmarksViewController) {
    viewController.rx.methodInvoked(#selector(BookmarksViewController.viewDidDisappear(_:)))
      .bind { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.coordinatorDidClose(strongSelf)
      }
      .disposed(by: self.disposeBag)
  }
}
