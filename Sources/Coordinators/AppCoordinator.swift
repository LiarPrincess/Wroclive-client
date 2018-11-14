// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator {

  let window: UIWindow
  let store:  Store<AppState>

  private var mainViewController: MainViewController?
  private var childCoordinator:   Coordinator?

  init(_ window: UIWindow, _ store: Store<AppState>) {
    self.window = window
    self.store  = store
  }

  func start() {
    let mapViewModel = MapViewModel(self.store, AppEnvironment.current)
    let viewModel = MainViewModel(self.store, mapViewModel)
    self.mainViewController = MainViewController(viewModel)

    viewModel.openSearchCard
      .drive(onNext: { [unowned self] in self.openSearchCard() })
      .disposed(by: viewModel.disposeBag)

    viewModel.openBookmarksCard
      .drive(onNext: { [unowned self] in self.openBookmarksCard() })
      .disposed(by: viewModel.disposeBag)

    viewModel.openSettingsCard
      .drive(onNext: { [unowned self] in self.openSettingsCard() })
      .disposed(by: viewModel.disposeBag)

    self.window.rootViewController = self.mainViewController
    self.window.makeKeyAndVisible()
  }

  private func openSearchCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = SearchCardCoordinator(mainViewController, self.store)
    self.childCoordinator!.start()
  }

  private func openBookmarksCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = BookmarksCardCoordinator(mainViewController, self.store)
    self.childCoordinator!.start()
  }

  private func openSettingsCard() {
    guard let mainViewController = self.mainViewController
      else { fatalError("AppCoordinator has to be started first") }

    self.childCoordinator = SettingsCardCoordinator(mainViewController)
    self.childCoordinator!.start()
  }
}
