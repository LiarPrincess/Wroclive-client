// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import PromiseKit

// swiftlint:disable weak_delegate

public final class SearchCardCoordinator: CardCoordinator {

  public let parent: UIViewController
  public let store: Store<AppState>
  public let environment: Environment

  public var card: SearchCard?
  public var cardTransitionDelegate: UIViewControllerTransitioningDelegate?

  public init(parent: UIViewController,
              store: Store<AppState>,
              environment: Environment) {
    self.parent = parent
    self.store = store
    self.environment = environment
  }

  public func start() -> Guarantee<Void> {
    let viewModel = SearchCardViewModel(store: self.store,environment: self.environment)
    let card = SearchCard(viewModel: viewModel, environment: self.environment)
    let height = 0.9 * self.environment.device.screenBounds.height
    return self.presentCard(card, withHeight: height, animated: true)
  }
}
