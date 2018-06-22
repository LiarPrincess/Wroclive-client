// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = CardPanelConstants.DismissGesture

class DismissGestureHandler: DismissGestureHandlerType {

  // MARK: - Properties

  weak var cardPanel: CardPanel! // swiftlint:disable:this implicitly_unwrapped_optional
  var      cardView:  UIView { return cardPanel.view }

  // MARK: - Init

  init(for cardPanel: CardPanel) {
    self.cardPanel = cardPanel
  }

  // MARK: - Handle gesture

  func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)

    case .changed:
      let translation = gesture.translation(in: self.cardView)
      self.updateCardTranslation(movement: translation.y)
      self.dismissIfBelowThreshold(movement: translation.y)
      self.dismissalGestureWillBegin()

    case .ended:
      self.moveCardToInitialPosition(animated: true)
      self.dismissalGestureDidEnd()

    default: break
    }
  }

  func resetGestureStartingPosition(_ gesture: UIPanGestureRecognizer) {
    gesture.setTranslation(.zero, in: self.cardView)
  }

  func updateCardTranslation(movement translation: CGFloat) {
    let isAboveStartingPosition = translation < 0

    if !isAboveStartingPosition {
      let modalTranslation    = self.easeOut(movement: translation)
      self.cardView.transform = CGAffineTransform(translationX: 0, y: modalTranslation)
    }
  }

  func easeOut(movement translation: CGFloat) -> CGFloat {
    if translation >= Constants.elasticThreshold {
      let frictionLength = translation - Constants.elasticThreshold
      let frictionTranslation = 30 * atan(frictionLength / 120) + frictionLength / 10
      return frictionTranslation + (Constants.elasticThreshold * Constants.translationFactor)
    }

    return translation * Constants.translationFactor
  }

  func dismissIfBelowThreshold(movement translation: CGFloat) {
    if translation >= Constants.dismissThreshold {
      self.cardPanel.dismiss(animated: true, completion: nil)
    }
  }

  func moveCardToInitialPosition(animated: Bool) {
    func inner() {
      self.cardView.transform = .identity
    }

    if animated { UIView.animate(withDuration: 0.25, animations: inner) }
    else        { inner() }
  }

  // MARK: - Card panel events

  private var hasStartedDismiss: Bool = false

  func dismissalGestureWillBegin() {
    if !self.hasStartedDismiss {
      self.cardPanel.dismissalGestureWillBegin()
      self.hasStartedDismiss = true
    }
  }

  func dismissalGestureDidEnd() {
    self.cardPanel.dismissalGestureDidEnd()
  }
}
