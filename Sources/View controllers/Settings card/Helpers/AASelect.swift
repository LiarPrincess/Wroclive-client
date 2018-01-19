//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let cell = self.tableViewDataSource.cellAt(indexPath)
//    switch cell {
//    case .personalization: self.delegate?.configurationViewControllerDidTapColorSelectionButton(self)
//    case .contact:         Managers.app.openWebsite()
//    case .share:           self.delegate?.configurationViewControllerDidTapShareButton(self)
//    case .rate:            Managers.app.rateApp()
//    }
//    tableView.deselectRow(at: indexPath, animated: true)
//  }

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
