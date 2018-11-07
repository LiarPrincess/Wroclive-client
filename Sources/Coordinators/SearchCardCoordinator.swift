// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

class SearchCardCoordinator: CardCoordinator {

  var card:                   SearchCard?
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  let parent: UIViewController

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

    self.presentCard(animated: true)
  }
}
