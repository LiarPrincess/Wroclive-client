//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = PushConstants.Transition

class PushDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let duration: TimeInterval

  init(_ duration: TimeInterval) {
    self.duration = duration
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let previousViewController  = transitionContext.viewController(forKey: .to)!
    let presentedViewController = transitionContext.viewController(forKey: .from)!

    // frames
    let viewWidth = containerView.bounds.width

    let previousOnScreenFrame  = previousViewController.view.frame
    var previousOffScreenFrame = previousOnScreenFrame
    previousOffScreenFrame.origin.x -= viewWidth * Constants.oldViewRelativeMovement

    let presentedOnScreenFrame  = presentedViewController.view.frame
    var presentedOffScreenFrame = presentedOnScreenFrame
    presentedOffScreenFrame.origin.x += viewWidth

    // animation
    previousViewController.view.frame = previousOffScreenFrame

    let duration = self.transitionDuration(using: transitionContext)
    let options: UIViewAnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseOut

    UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
      presentedViewController.view.frame = presentedOffScreenFrame
      previousViewController.view.frame  = previousOnScreenFrame
    }, completion: { _ in
      presentedViewController.view.frame = presentedOnScreenFrame
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
