//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: SearchCoordinator)
}

class SearchCoordinator: CardPanelCoordinator {

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: SearchCoordinatorDelegate?

  private let disposeBag = DisposeBag()

  init(parent: UIViewController, delegate: SearchCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let viewModel      = SearchViewModel()
    let viewController = SearchViewController(viewModel)
    self.bindOnClosed(viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

  private func bindOnClosed(_ viewController: SearchViewController) {
    viewController.rx.methodInvoked(#selector(SearchViewController.viewDidDisappear(_:)))
      .bind { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.coordinatorDidClose(strongSelf)
      }
      .disposed(by: self.disposeBag)
  }
}
