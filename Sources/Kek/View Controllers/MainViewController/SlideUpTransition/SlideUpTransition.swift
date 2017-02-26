//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class SlideUpPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.35
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let modalViewController = transitionContext.viewController(forKey: .to)!

    let modalOnScreenFrame = transitionContext.finalFrame(for: modalViewController)
    var modalOffScreenFrame = modalOnScreenFrame
    modalOffScreenFrame.origin.y = transitionContext.containerView.bounds.height

    //animation
    modalViewController.view.frame = modalOffScreenFrame
    transitionContext.containerView.addSubview(modalViewController.view)

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
      modalViewController.view.frame = modalOnScreenFrame
    }, completion: { completed in
      transitionContext.completeTransition(completed)
    })
  }

}

class SlideUpDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let mainViewController = transitionContext.viewController(forKey: .to)! as! MainViewController
    let modalViewController = transitionContext.viewController(forKey: .from)!

    let onScreenTransform = CGAffineTransform.identity
    let offScreenTransform = CGAffineTransform(translationX: 0, y: transitionContext.containerView.bounds.height)

    //animation
    let toolbar = mainViewController.buttonContainerView!

    toolbar.transform = offScreenTransform
    modalViewController.view.transform = onScreenTransform

    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: .calculationModeCubic, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.6) {
        modalViewController.view.transform = offScreenTransform
      }

      UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
        toolbar.transform = onScreenTransform
      }
    }, completion: { completed in
      transitionContext.completeTransition(completed)
    })
  }
  
}
