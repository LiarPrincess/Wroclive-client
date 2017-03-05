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
      transitionContext.completeTransition(completed)
    })
  }

}

class CardPanelDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return CardPanelConstants.AnimationDuration.dismiss
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//    let mainViewController = transitionContext.viewController(forKey: .to)! as! MainViewController
    let modalViewController = transitionContext.viewController(forKey: .from)!

    let onScreenTransform = CGAffineTransform.identity
    let offScreenTransform = CGAffineTransform(translationX: 0, y: transitionContext.containerView.bounds.height)

    //animation
    modalViewController.view.transform = onScreenTransform

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
      modalViewController.view.transform = offScreenTransform
    }, completion: { completed in
      modalViewController.view.transform = onScreenTransform
      transitionContext.completeTransition(completed)
    })
  }
  
}
