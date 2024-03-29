// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = CardContainer.Constants.DismissGesture

internal class DismissGestureHandler {

  // MARK: - Properties

  internal unowned var card: CardContainer

  // MARK: - Init

  internal init(card: CardContainer) {
    self.card = card
  }

  // MARK: - Handle gesture

  internal func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)
      self.notifyInteractiveDismissalWillBegin()

    case .changed:
      let translation = gesture.translation(in: self.card.view)
      self.updateCardTranslation(movement: translation.y)
      self.dismissIfBelowThreshold(movement: translation.y)

      let percent = translation.y / Constants.dismissThreshold
      self.notifyInteractiveDismissalProgress(percent: percent)

    // Ended means that user lifted their finger without dismissing
    case .ended:
      self.moveCardToInitialPosition(animated: true)
      self.notifyInteractiveDismissalDidEnd(completed: false)

    // Cancelled means that gesture was interrupted in the middle
    // (for example by dismiss)
    case .cancelled:
      self.notifyInteractiveDismissalDidEnd(completed: true)

    default:
      break
    }
  }

  internal func resetGestureStartingPosition(_ gesture: UIPanGestureRecognizer) {
    gesture.setTranslation(.zero, in: self.card.view)
  }

  internal func updateCardTranslation(movement translation: CGFloat) {
    let isAboveStartingPosition = translation < 0

    if !isAboveStartingPosition {
      let modalTranslation = self.easeOut(movement: translation)
      self.card.view.transform = CGAffineTransform(
        translationX: 0,
        y: modalTranslation
      )
    }
  }

  internal func easeOut(movement translation: CGFloat) -> CGFloat {
    if translation >= Constants.elasticThreshold {
      let frictionLength = translation - Constants.elasticThreshold
      let frictionTranslation = 30 * atan(frictionLength / 120) + frictionLength / 10
      return frictionTranslation + (Constants.elasticThreshold * Constants.translationFactor)
    }

    return translation * Constants.translationFactor
  }

  internal func dismissIfBelowThreshold(movement translation: CGFloat) {
    if translation >= Constants.dismissThreshold {
      self.card.dismiss(animated: true, completion: nil)
    }
  }

  internal func moveCardToInitialPosition(animated: Bool) {
    func inner() {
      self.card.view.transform = .identity
    }

    if animated {
      let duration = CardContainer.Constants.AnimationDurations.failedGestureDismiss
      UIView.animate(withDuration: duration, animations: inner)
    } else {
      inner()
    }
  }

  // MARK: - Card panel events

  // In case of scroll view we don't really know if touch was first or not
  private var hasStartedDismiss = false

  internal func notifyInteractiveDismissalWillBegin() {
    if !self.hasStartedDismiss {
      self.card.interactiveDismissalWillBegin()
      self.hasStartedDismiss = true
    }
  }

  internal func notifyInteractiveDismissalProgress(percent: CGFloat) {
    self.card.interactiveDismissalProgress(percent: percent)
  }

  internal func notifyInteractiveDismissalDidEnd(completed: Bool) {
    self.card.interactiveDismissalDidEnd(completed: completed)
  }
}
