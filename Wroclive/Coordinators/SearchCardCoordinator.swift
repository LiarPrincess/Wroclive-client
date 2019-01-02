// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

class SearchCardCoordinator: CardCoordinator {

  let parent: UIViewController
  let store:  Store<AppState>

  var card:                   SearchCard?
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  init(_ parent: UIViewController, _ store: Store<AppState>) {
    self.parent = parent
    self.store  = store
  }

  func start() {
    let viewModel = SearchCardViewModel(self.store)
    self.card     = SearchCard(viewModel)
    self.presentCard(animated: true)
  }
}
