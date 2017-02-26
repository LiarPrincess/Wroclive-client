//
//  Created by NoPoint
//  Copyright © 2017 NoPoint. All rights reserved.
//

import Foundation
import UIKit


class SlideUpPresenter : UIPresentationController {

  //MARK: - Properties

  private var dimmingView: UIView?
  private var relativeHeight: CGFloat

  //MARK: - Constructors

  init(forPresented presented: UIViewController, presenting: UIViewController?, relativeHeight: CGFloat) {
    self.relativeHeight = relativeHeight
    super.init(presentedViewController: presented, presenting: presenting)
  }

  //MARK: - Overriden

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return super.frameOfPresentedViewInContainerView
    }

    let height = containerView.bounds.height * relativeHeight
    let y = containerView.bounds.height - height
    return CGRect(x: 0.0, y: y, width: containerView.bounds.width, height: height)
  }

  override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator else {
      return
    }

    self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
    self.dimmingView!.backgroundColor = .darkGray
    self.dimmingView!.alpha = 0

    containerView.addSubview(self.dimmingView!)
    self.dimmingView!.addSubview(presentedViewController.view)

    coordinator.animate(alongsideTransition: { [weak self] context in
      self!.dimmingView!.alpha = 0.5
    }, completion: nil)
  }

  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentingViewController.transitionCoordinator else {
      return
    }

    coordinator.animate(alongsideTransition: { [weak self] context in
      self!.dimmingView!.alpha = 0
    }, completion: nil)
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      self.dimmingView!.removeFromSuperview()
      self.dimmingView = nil
    }
  }

}
