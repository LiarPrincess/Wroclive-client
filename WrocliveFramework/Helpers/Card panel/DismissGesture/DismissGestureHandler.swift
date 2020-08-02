// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Constants = CardPanelConstants.DismissGesture

public class DismissGestureHandler: DismissGestureHandlerType {

  // MARK: - Properties

  // swiftlint:disable:next implicitly_unwrapped_optional
  public weak var presentedViewController: UIViewController!
  public var      presentedView:  UIView { return presentedViewController.view }

  public var cardPanel: CustomCardPanelPresentable? {
    return self.presentedViewController as? CustomCardPanelPresentable
  }

  // MARK: - Init

  public init(for presentedViewController: UIViewController) {
    self.presentedViewController = presentedViewController
  }

  // MARK: - Handle gesture

  public func handleGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.resetGestureStartingPosition(gesture)
      self.notifyInteractiveDismissalWillBegin()

    case .changed:
      let translation = gesture.translation(in: self.presentedView)
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

    default: break
    }
  }

  public func resetGestureStartingPosition(_ gesture: UIPanGestureRecognizer) {
    gesture.setTranslation(.zero, in: self.presentedView)
  }

  public func updateCardTranslation(movement translation: CGFloat) {
    let isAboveStartingPosition = translation < 0

    if !isAboveStartingPosition {
      let modalTranslation    = self.easeOut(movement: translation)
      self.presentedView.transform = CGAffineTransform(
        translationX: 0,
        y: modalTranslation
      )
    }
  }

  public func easeOut(movement translation: CGFloat) -> CGFloat {
    if translation >= Constants.elasticThreshold {
      let frictionLength = translation - Constants.elasticThreshold
      let frictionTranslation = 30 * atan(frictionLength / 120) + frictionLength / 10
      return frictionTranslation + (Constants.elasticThreshold * Constants.translationFactor)
    }

    return translation * Constants.translationFactor
  }

  public func dismissIfBelowThreshold(movement translation: CGFloat) {
    if translation >= Constants.dismissThreshold {
      self.presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

  public func moveCardToInitialPosition(animated: Bool) {
    func inner() {
      self.presentedView.transform = .identity
    }

    if animated { UIView.animate(withDuration: 0.25, animations: inner) }
    else        { inner() }
  }

  // MARK: - Card panel events

  // in case of scroll view we don't really know if touch was first or not
  private var hasStartedDismiss: Bool = false

  public func notifyInteractiveDismissalWillBegin() {
    if !self.hasStartedDismiss {
      self.cardPanel?.interactiveDismissalWillBegin()
      self.hasStartedDismiss = true
    }
  }

  public func notifyInteractiveDismissalProgress(percent: CGFloat) {
    self.cardPanel?.interactiveDismissalProgress(percent: percent)
  }

  public func notifyInteractiveDismissalDidEnd(completed: Bool) {
    self.cardPanel?.interactiveDismissalDidEnd(completed: completed)
  }
}
