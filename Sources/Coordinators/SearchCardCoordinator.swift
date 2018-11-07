// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

class SearchCardCoordinator: CoordinatorType {

  private var card:                   SearchCard?
  private var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  private let parent: UIViewController

  init(_ parent: UIViewController) {
    self.parent = parent
  }

  func start() {
    let viewModel = SearchCardViewModel()
    self.card     = SearchCard(viewModel)

    viewModel.startTracking
      .drive(onNext: { [weak self] lines in
        AppEnvironment.live.startTracking(lines)
        self?.card?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)

    self.cardTransitionDelegate = CardPanelTransitionDelegate(for: self.card!)
    self.card!.modalPresentationStyle = .custom
    self.card!.transitioningDelegate  = self.cardTransitionDelegate!

    self.parent.present(self.card!, animated: true, completion: nil)
  }
}
