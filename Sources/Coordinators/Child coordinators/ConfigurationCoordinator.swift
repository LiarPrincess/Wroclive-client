//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit
import RxSwift

protocol ConfigurationCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: ConfigurationCoordinator)
}

class ConfigurationCoordinator: CardPanelCoordinator {

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: ConfigurationCoordinatorDelegate?

  private let disposeBag = DisposeBag()

  init(parent: UIViewController, delegate: ConfigurationCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let viewModel      = SettingsCardViewModel()
    let viewController = SettingsCard(viewModel)
    self.bindOnClosed(viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

  private func bindOnClosed(_ viewController: SettingsCard) {
    viewController.rx.methodInvoked(#selector(SearchCard.viewDidDisappear(_:)))
      .bind { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.coordinatorDidClose(strongSelf)
      }
      .disposed(by: self.disposeBag)
  }
}
