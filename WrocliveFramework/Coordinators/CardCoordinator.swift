// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

internal protocol CardCoordinator: class {
  var parent: UIViewController { get }
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }

  /// Call this to open card.
  func start() -> Guarantee<Void>
}

extension CardCoordinator {

  /// Helper!
  /// Should be called only inside `CardCoordinator` implementation!
  internal func present(card: UIViewController,
                        withHeight height: CGFloat,
                        animated: Bool) -> Guarantee<Void> {
    self.cardTransitionDelegate = CardPanelTransitionDelegate(height: height)

    return Guarantee<Void> { resolve in
      let container = CardPanelContainer(onViewDidDisappear: { resolve(()) })
      container.setContent(card)
      container.modalPresentationStyle = .custom
      container.transitioningDelegate = self.cardTransitionDelegate!
      self.parent.present(container, animated: animated, completion: nil)
    }
  }
}
