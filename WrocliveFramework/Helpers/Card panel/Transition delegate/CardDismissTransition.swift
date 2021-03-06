// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal final class CardDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let duration: TimeInterval

  internal init(_ duration: TimeInterval) {
    self.duration = duration
  }

  internal func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return self.duration
  }

  internal func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    guard let presentedViewController = transitionContext.viewController(forKey: .from)
      else { return }

    let containerView = transitionContext.containerView

    let onScreenFrame = transitionContext.initialFrame(for: presentedViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = containerView.bounds.height

    // animation

    let options: UIView.AnimationOptions = transitionContext.isInteractive ?
      .curveLinear :
      .curveEaseOut

    UIView.animate(
      withDuration: self.transitionDuration(using: transitionContext),
      delay: 0.0,
      options: options,
      animations: { presentedViewController.view.frame = offScreenFrame },
      completion: { transitionContext.completeTransition($0) }
    )
  }
}
