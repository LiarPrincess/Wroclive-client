// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

class AppCoordinator: CoordinatorType {

  private let window: UIWindow
  private var mainViewController: MainViewController?

  private var card:                   UIViewController?
  private var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  init(_ window: UIWindow) {
    self.window = window
  }

  func start() {
    let viewModel = MainViewModel()
    self.mainViewController = MainViewController(viewModel)

    viewModel.openSearchCard
      .drive(onNext: { [unowned self] in self.openSearchCard() })
      .disposed(by: viewModel.disposeBag)

    viewModel.openBookmarksCard
      .drive(onNext: { [unowned self] in self.openBookmarksCard() })
      .disposed(by: viewModel.disposeBag)

    viewModel.openConfigurationCard
      .drive(onNext: { [unowned self] in self.openConfigurationCard() })
      .disposed(by: viewModel.disposeBag)

    window.rootViewController = self.mainViewController
    window.makeKeyAndVisible()
  }

  private func openSearchCard() {
    let viewModel      = SearchCardViewModel()
    let viewController = SearchCard(viewModel)

    viewModel.startTracking
      .drive(onNext: { [weak viewController] lines in
        AppEnvironment.live.startTracking(lines)
        viewController?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)

    self.openCard(viewController, animated: true)
  }

  private func openBookmarksCard() {
    let viewModel      = BookmarksCardViewModel()
    let viewController = BookmarksCard(viewModel)

    viewModel.startTracking
      .drive(onNext: { [weak viewController] bookmark in
        AppEnvironment.live.startTracking(bookmark.lines)
        viewController?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)

    self.openCard(viewController, animated: true)
  }

  private func openConfigurationCard() {
    let viewModel      = SettingsCardViewModel()
    let viewController = SettingsCard(viewModel)
    self.openCard(viewController, animated: true)
  }

  private func openCard(_ cardPanel: CardPanel, animated: Bool) {
    if let currentCard = self.card {
      currentCard.dismiss(animated: true) { [unowned self] in
        self.card = nil
        self.cardTransitionDelegate = nil
        self.openCardInner(cardPanel, animated: animated)
      }
    }
    else { self.openCardInner(cardPanel, animated: animated) }
  }

  private func openCardInner(_ cardPanel: CardPanel, animated: Bool) {
    guard let mainViewController = self.mainViewController
    else { fatalError("AppCoordinator has to be started first") }

    self.cardTransitionDelegate = CardPanelTransitionDelegate(for: cardPanel)
    cardPanel.modalPresentationStyle = .custom
    cardPanel.transitioningDelegate  = self.cardTransitionDelegate!

    mainViewController.present(cardPanel, animated: animated, completion: nil)
  }
}
