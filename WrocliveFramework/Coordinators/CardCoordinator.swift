// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import PromiseKit

// swiftlint:disable trailing_closure

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
  internal func present(card: CardPresentable, animated: Bool) -> Guarantee<Void> {
    let screenHeight = self.environment.device.screenBounds.height
    let cardHeight = Self.getCardHeight(screenHeight: screenHeight)

    let transitionDelegate = CardTransitionDelegate(height: cardHeight)
    self.cardTransitionDelegate = transitionDelegate

    return Guarantee<Void> { resolve in
      let container = CardContainer(onViewDidDisappear: { resolve(()) })
      container.setContent(card)
      container.modalPresentationStyle = .custom
      container.transitioningDelegate = transitionDelegate
      self.parent.present(container, animated: animated, completion: nil)
    }
  }

  internal static func getCardHeight(screenHeight: CGFloat) -> CGFloat {
    // |Name         |ScreenHeight|MaxOneHandHeight|ScreenPercent|
    // +-------------+------------+----------------+-------------+
    // |iPhoneSe     |         568|             600|         *454|
    // |iPhone8      |         667|             600|         *533|
    // |iPhone8 Plus |         736|             600|         *588|
    // |iPhoneX      |         812|            *600|          649|
    // |iPhoneX Max  |         896|            *600|          716|

    let screenPercent = CGFloat(0.8) * screenHeight
    let maxOneHandHeight = CGFloat(600.0)
    return Swift.min(screenPercent, maxOneHandHeight)
  }
}
