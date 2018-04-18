//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias AnimationDurations = CardPanelConstants.AnimationDurations

class CardPanelDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let duration: TimeInterval

  init(_ duration: TimeInterval) {
    self.duration = duration
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presentedViewController = transitionContext.viewController(forKey: .from)
      else { return }

    let containerView = transitionContext.containerView

    let onScreenFrame  = transitionContext.initialFrame(for: presentedViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = containerView.bounds.height

    // animation

    let duration = self.transitionDuration(using: transitionContext)
    let options: UIViewAnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseOut

    UIView.animate(
      withDuration: duration,
      delay:        0.0,
      options:      options,
      animations:   { presentedViewController.view.frame = offScreenFrame },
      completion:   { _ in transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
    )
  }
}