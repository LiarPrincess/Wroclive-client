// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

// swiftlint:disable trailing_closure

internal protocol CardCoordinator: AnyObject {
  var parent: UIViewController { get }
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }

  /// Call this to open card.
  func start() -> Guarantee<Void>
}

extension CardCoordinator {

  /// Helper!
  /// Should be called only inside `CardCoordinator` implementation!
  internal func present(card: CardPresentable,
                        withHeight height: CGFloat,
                        animated: Bool) -> Guarantee<Void> {
    let transitionDelegate = CardPanelTransitionDelegate(height: height)
    self.cardTransitionDelegate = transitionDelegate

    return Guarantee<Void> { resolve in
      let container = CardContainer(onViewDidDisappear: { resolve(()) })
      container.setContent(card)
      container.modalPresentationStyle = .custom
      container.transitioningDelegate = transitionDelegate
      self.parent.present(container, animated: animated, completion: nil)
    }
  }
}
