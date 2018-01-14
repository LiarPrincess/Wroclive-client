//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = PushConstants.Transition

class PushPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let duration: TimeInterval

  init(_ duration: TimeInterval) {
    self.duration = duration
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.duration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let previousViewController  = transitionContext.viewController(forKey: .from)!
    let presentedViewController = transitionContext.viewController(forKey: .to)!

    // frames
    let viewWidth = containerView.bounds.width

    let previousOnScreenFrame  = previousViewController.view.frame
    var previousOffScreenFrame = previousOnScreenFrame
    previousOffScreenFrame.origin.x -= viewWidth * Constants.oldViewRelativeMovement

    let presentedOnScreenFrame  = presentedViewController.view.frame
    var presentedOffScreenFrame = presentedOnScreenFrame
    presentedOffScreenFrame.origin.x += viewWidth

    // animation
    containerView.addSubview(presentedViewController.view)
    presentedViewController.view.frame = presentedOffScreenFrame

    let duration = self.transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
      presentedViewController.view.frame = presentedOnScreenFrame
      previousViewController.view.frame  = previousOffScreenFrame
    }, completion: { _ in
      previousViewController.view.frame = previousOnScreenFrame
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
