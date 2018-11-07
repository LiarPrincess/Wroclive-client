// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: CoordinatorType {

  private let window: UIWindow
  private var mainViewController: MainViewController?

  private var childCoordinator: CoordinatorType?

  init(_ window: UIWindow) {
    self.window = window
  }

  func start() {
    let viewModel = MainViewModel()
    self.mainViewController = MainViewController(viewModel)

    viewModel.openSearchCard
      .drive(onNext: { [unowned self] in self.open(SearchCardCoordinator.init) })
      .disposed(by: viewModel.disposeBag)

    viewModel.openBookmarksCard
      .drive(onNext: { [unowned self] in self.open(BookmarksCardCoordinator.init) })
      .disposed(by: viewModel.disposeBag)

    viewModel.openSettingsCard
      .drive(onNext: { [unowned self] in self.open(SettingsCardCoordinator.init) })
      .disposed(by: viewModel.disposeBag)

    self.window.rootViewController = self.mainViewController
    self.window.makeKeyAndVisible()
  }

  private func open(_ coordinatorInit: (UIViewController) -> CoordinatorType) {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = coordinatorInit(mainViewController)
    self.childCoordinator!.start()
  }
}
