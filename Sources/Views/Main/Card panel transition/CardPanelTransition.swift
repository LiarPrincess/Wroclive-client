//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class CardPanelPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return CardPanelConstants.AnimationDuration.present
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let modalViewController = transitionContext.viewController(forKey: .to)!

    let onScreenFrame = transitionContext.finalFrame(for: modalViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = transitionContext.containerView.bounds.height

    //animation
    modalViewController.view.frame = offScreenFrame

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
      modalViewController.view.frame = onScreenFrame
    }, completion: { completed in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }

}

class CardPanelDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return CardPanelConstants.AnimationDuration.dismiss
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let modalViewController = transitionContext.viewController(forKey: .from)!

    let onScreenFrame = transitionContext.initialFrame(for: modalViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = transitionContext.containerView.bounds.height

    //animation
    let duration = transitionDuration(using: transitionContext)
    let options: UIViewAnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseInOut

    UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
      modalViewController.view.frame = offScreenFrame
    }, completion: { completed in
      modalViewController.view.frame = onScreenFrame
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
}
