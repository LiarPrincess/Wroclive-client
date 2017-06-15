//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

class CardPanelPresenter : UIPresentationController {

  //MARK: - Properties
  
  private var dimmingView:    UIView?
  private var relativeHeight: CGFloat

  //MARK: - Init

  init(forPresented presented: UIViewController, presenting: UIViewController?, relativeHeight: CGFloat) {
    self.relativeHeight = relativeHeight
    super.init(presentedViewController: presented, presenting: presenting)
  }

  //MARK: - Frame

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return super.frameOfPresentedViewInContainerView
    }

    let viewHeight    = containerView.bounds.height * relativeHeight
    let viewTopOffset = containerView.bounds.height - viewHeight
    return CGRect(x: 0.0, y: viewTopOffset, width: containerView.bounds.width, height: viewHeight)
  }

  //MARK: - Presentation

  override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator else {
      return
    }

    self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
    self.dimmingView!.backgroundColor = CardPanelConstants.Presenter.backgroundColor
    self.dimmingView!.alpha = 0

    containerView.addSubview(self.dimmingView!)
    containerView.addSubview(self.presentedViewController.view)

    coordinator.animate(alongsideTransition: { [weak self] context in
      self?.dimmingView!.alpha = CardPanelConstants.Presenter.backgroundAlpha
    }, completion: nil)
  }

  //MARK: - Dismiss

  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentingViewController.transitionCoordinator else {
      return
    }

    if let presentable = self.presentedViewController as? CardPanelPresentable {
      presentable.dismissalTransitionWillBegin()
    }

    coordinator.animate(alongsideTransition: { [weak self] context in
      self?.dimmingView!.alpha = 0
    }, completion: nil)
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    if let presentable = self.presentedViewController as? CardPanelPresentable {
      presentable.dismissalTransitionDidEnd(completed)
    }

    if completed {
      self.dimmingView?.removeFromSuperview()
      self.dimmingView = nil
    }
  }

}
