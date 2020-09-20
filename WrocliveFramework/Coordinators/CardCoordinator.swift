// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

internal protocol CardCoordinator: AnyObject {
  var parent: UIViewController { get }
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }

  var environment: Environment { get }

  /// Call this to open card.
  func start(animated: Bool) -> Guarantee<Void>
}

extension CardCoordinator {

  /// Helper!
  /// Should be called only inside `CardCoordinator` implementation!
  internal func present(card: CardPresentable,
                        withHeight height: CGFloat,
                        animated: Bool) -> Guarantee<Void> {
    let transitionDelegate = CardTransitionDelegate(height: height)
    self.cardTransitionDelegate = transitionDelegate

    return Guarantee<Void> { resolve in
      // swiftlint:disable:next trailing_closure
      let container = CardContainer(onViewDidDisappear: { resolve(()) })
      container.setContent(card)
      container.modalPresentationStyle = .custom
      container.transitioningDelegate = transitionDelegate
      self.parent.present(container, animated: animated, completion: nil)
    }
  }

  /// We will define card height as percent of screen height.
  ///
  /// But at some point it would be to hard to reach with 1 hand
  /// (or it would look weird), so there is another limit in place.
  internal func getCardHeight(screenPercent: CGFloat,
                              butNoBiggerThan maxHeight: CGFloat) -> CGFloat {
    let screenHeight = self.environment.device.screenBounds.height
    let percentHeight = screenPercent * screenHeight
    return Swift.min(percentHeight, maxHeight)
  }
}
