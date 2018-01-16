//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

protocol ConfigurationCoordinatorDelegate: class {
  func coordinatorDidClose(_ coordinator: ConfigurationCoordinator)
}

class ConfigurationCoordinator: CardPanelCoordinator {

  var childCoordinators: [Coordinator] = []
  var cardPanelTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  weak var parent:   UIViewController?
  weak var delegate: ConfigurationCoordinatorDelegate?

  init(parent: UIViewController, delegate: ConfigurationCoordinatorDelegate) {
    self.parent   = parent
    self.delegate = delegate
  }

  func start() {
    guard let parent = self.parent else { return }

    let viewController = SettingsCard()
//    self.bindOnClosed(viewController)
    self.presentCardPanel(viewController, in: parent, animated: true)
  }

//  private func bindOnClosed(_ viewController: SearchCard) {
//    viewController.rx.methodInvoked(#selector(SearchCard.viewDidDisappear(_:)))
//      .bind { [weak self] _ in
//        guard let strongSelf = self else { return }
//        strongSelf.delegate?.coordinatorDidClose(strongSelf)
//      }
//      .disposed(by: self.disposeBag)
//  }
}

//extension ConfigurationCoordinator: ConfigurationViewControllerDelegate, ColorSelectionCoordinatorDelegate {
//
//  // MARK: - Close
//
//  func configurationViewControllerDidClose(_ viewController: ConfigurationViewController) {
//    self.delegate?.coordinatorDidClose(self)
//  }
//
//  // MARK: - Color selection
//
//  func configurationViewControllerDidTapColorSelectionButton(_ viewController: ConfigurationViewController) {
//    let coordinator = ColorSelectionCoordinator(parent: viewController, delegate: self)
//    self.childCoordinators.append(coordinator)
//    coordinator.start()
//  }
//
//  func coordinatorDidClose(_ coordinator: ColorSelectionCoordinator) {
//    self.removeChildCoordinator(coordinator)
//  }
//
//  // MARK: Share
//
//  func configurationViewControllerDidTapShareButton(_ viewController: ConfigurationViewController) {
//    // Retain parent for a moment (intended)
//    guard let parent = self.parent else { return }
//
//    viewController.dismiss(animated: true) {
//      Managers.app.showShareActivity(in: parent)
//    }
//  }
//}
