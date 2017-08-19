//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let transitionDuration: TimeInterval

  init(_ transitionDuration: TimeInterval) {
    self.transitionDuration = transitionDuration
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.transitionDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let modalViewController = transitionContext.viewController(forKey: .from)!

    let onScreenFrame  = transitionContext.initialFrame(for: modalViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = transitionContext.containerView.bounds.height

    //animation
    let duration = transitionDuration(using: transitionContext)
    let options: UIViewAnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseOut

    UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
      modalViewController.view.frame = offScreenFrame
    }, completion: { _ in
      modalViewController.view.frame = onScreenFrame
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }

}
