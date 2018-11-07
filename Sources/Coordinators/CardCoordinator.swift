// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

protocol CardCoordinator: class, Coordinator {
  associatedtype Card: CardPanel

  var card:                   Card? { get }
  var cardTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }

  var parent: UIViewController { get }
}

extension CardCoordinator {

  func presentCard(animated: Bool) {
    guard let card = self.card
      else { fatalError("CardCoordinator.card was not set before calling presentCard") }

    self.cardTransitionDelegate = CardPanelTransitionDelegate(for: card)
    card.modalPresentationStyle = .custom
    card.transitioningDelegate  = self.cardTransitionDelegate!

    self.parent.present(card, animated: animated, completion: nil)
  }
}
