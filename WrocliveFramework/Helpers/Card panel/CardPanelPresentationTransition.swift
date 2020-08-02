// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

public final class CardPanelPresentationTransition:
  NSObject, UIViewControllerAnimatedTransitioning
{

  private let duration: TimeInterval

  public init(_ duration: TimeInterval) {
    self.duration = duration
  }

  public func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return self.duration
  }

  public func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard let presentedViewController = transitionContext.viewController(forKey: .to)
      else { return }

    let containerView = transitionContext.containerView
    containerView.addSubview(presentedViewController.view)

    let onScreenFrame  = transitionContext.finalFrame(for: presentedViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = containerView.bounds.height

    // animation

    presentedViewController.view.frame = offScreenFrame

    UIView.animate(
      withDuration: self.transitionDuration(using: transitionContext),
      delay:        0.0,
      options:      .curveEaseOut,
      animations:   { presentedViewController.view.frame = onScreenFrame },
      completion:   { transitionContext.completeTransition($0) }
    )
  }
}
