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
    self.bindViewModel(viewModel, viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

  private func bindViewModel(_ viewModel: BookmarksViewModel, _ viewController: BookmarksViewController) {
    viewModel.outputs.selectedItem
      .drive(onNext: { (bookmark: Bookmark) -> Void in
        Managers.tracking.start(bookmark.lines)
        viewController.dismiss(animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    viewModel.outputs.didClose
      .drive(onNext: { self.delegate?.coordinatorDidClose(self) })
      .disposed(by: self.disposeBag)
  }
}
