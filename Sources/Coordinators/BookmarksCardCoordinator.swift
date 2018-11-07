// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import RxSwift
import RxCocoa

class BookmarksCardCoordinator: CardCoordinator {

  var card:                   BookmarksCard?
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  let parent: UIViewController

  init(_ parent: UIViewController) {
    self.parent = parent
  }

  func start() {
    let viewModel = BookmarksCardViewModel()
    self.card     = BookmarksCard(viewModel)

    viewModel.startTracking
      .drive(onNext: { [weak self] bookmark in
        AppEnvironment.live.startTracking(bookmark.lines)
        self?.card?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)

    self.presentCard(animated: true)
  }
}
