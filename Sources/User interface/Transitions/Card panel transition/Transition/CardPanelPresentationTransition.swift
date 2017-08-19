//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

  private let transitionDuration: TimeInterval

  init(_ transitionDuration: TimeInterval) {
    self.transitionDuration = transitionDuration
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.transitionDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let modalViewController = transitionContext.viewController(forKey: .to)!

    let onScreenFrame  = transitionContext.finalFrame(for: modalViewController)
    var offScreenFrame = onScreenFrame
    offScreenFrame.origin.y = transitionContext.containerView.bounds.height

    //animation
    modalViewController.view.frame = offScreenFrame

    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
      modalViewController.view.frame = onScreenFrame
    }, completion: { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }

}
