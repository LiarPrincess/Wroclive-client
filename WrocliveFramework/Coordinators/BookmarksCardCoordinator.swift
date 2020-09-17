// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

// swiftlint:disable weak_delegate

public final class BookmarksCardCoordinator: CardCoordinator {

  public internal(set) var card: BookmarksCard?
  internal let parent: UIViewController
  internal var cardTransitionDelegate: UIViewControllerTransitioningDelegate?

  public let store: Store<AppState>
  public let environment: Environment

  public init(parent: UIViewController,
              store: Store<AppState>,
              environment: Environment) {
    self.parent = parent
    self.store = store
    self.environment = environment
  }

  public func start(animated: Bool) -> Guarantee<Void> {
    let viewModel = BookmarksCardViewModel(store: self.store)
    let card = BookmarksCard(viewModel: viewModel)

    self.card = card
    return self.present(card: card, animated: animated)
  }
}
