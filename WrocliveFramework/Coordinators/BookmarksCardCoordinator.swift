// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import ReSwift
import RxSwift
import RxCocoa

public final class BookmarksCardCoordinator: CardCoordinator {

  public let parent: UIViewController
  public let store:  Store<AppState>

  public var card:                   BookmarksCard?
  public var cardTransitionDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate

  public init(_ parent: UIViewController, _ store: Store<AppState>) {
    self.parent = parent
    self.store  = store
  }

  public func start() {
    let viewModel = BookmarksCardViewModel(self.store)
    let card      = BookmarksCard(viewModel)
    let height    = 0.75 * AppEnvironment.device.screenBounds.height
    self.presentCard(card, withHeight: height, animated: true)
  }
}
