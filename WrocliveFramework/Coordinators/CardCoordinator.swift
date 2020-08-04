// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public protocol CardCoordinator: class, Coordinator {
  associatedtype Card: UIViewController

  var card: Card? { get set }
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }

  var parent: UIViewController { get }
}

public extension CardCoordinator {

  func presentCard(_ card: Card, withHeight height: CGFloat, animated: Bool) {
    guard self.card == nil else {
      fatalError("Card was already presented!")
    }

    self.card = card
    self.cardTransitionDelegate = CardPanelTransitionDelegate(height: height)

    let container = CardPanelContainer()
    container.setContent(card)
    container.modalPresentationStyle = .custom
    container.transitioningDelegate  = self.cardTransitionDelegate!

    self.parent.present(container, animated: animated, completion: nil)
  }
}
