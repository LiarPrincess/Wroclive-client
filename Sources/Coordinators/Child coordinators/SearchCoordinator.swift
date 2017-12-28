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
    self.bindViewModel(viewModel, viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

  private func bindViewModel(_ viewModel: SearchViewModel, _ viewController: SearchViewController) {
    viewModel.outputs.searchButtonPressed
      .withLatestFrom(viewModel.outputs.selectedLines) { $1 }
      .drive(onNext: { (lines: [Line]) -> Void in
        Managers.tracking.start(lines)
        viewController.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    viewModel.outputs.didClose
      .drive(onNext: { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.coordinatorDidClose(strongSelf)
      })
      .disposed(by: self.disposeBag)
  }
}
