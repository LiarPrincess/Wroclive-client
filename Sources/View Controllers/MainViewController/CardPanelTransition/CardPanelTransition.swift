//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit

class CardPanelPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

  typealias Constants = MainViewControllerConstants.CardPanelTransition

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.AnimationDuration.present
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

class CardPanelDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  typealias Constants = MainViewControllerConstants.CardPanelTransition

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.AnimationDuration.dismiss
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
      let slideDownDuration = Constants.AnimationDuration.dismissTimingDistribution

      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: slideDownDuration) {
        modalViewController.view.transform = offScreenTransform
      }

      UIView.addKeyframe(withRelativeStartTime: slideDownDuration, relativeDuration: 1.0 - slideDownDuration) {
        toolbar.transform = onScreenTransform
      }
    }, completion: { completed in
      transitionContext.completeTransition(completed)
    })
  }
  
}
