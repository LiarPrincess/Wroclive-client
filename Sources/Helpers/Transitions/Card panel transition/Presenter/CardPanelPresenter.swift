//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Constants = CardPanelConstants.Presenter

class CardPanelPresenter : UIPresentationController {

  // MARK: - Properties

  private var chevronView: ChevronView?
  private var dimmingView: UIView?

  private weak var presentable: CardPanelPresentable?

  // MARK: - Init

  init(forPresented presented: UIViewController, presenting: UIViewController?, as presentable: CardPanelPresentable?) {
    self.presentable = presentable
    super.init(presentedViewController: presented, presenting: presenting)
  }

  // MARK: - Frame

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return .zero
    }

    let viewHeight = self.presentable?.height ?? containerView.bounds.height
    let topOffset  = containerView.bounds.height - viewHeight
    return CGRect(x: 0.0, y: topOffset, width: containerView.bounds.width, height: viewHeight)
  }

  // MARK: - Presentation

  override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView,
          let coordinator   = self.presentingViewController.transitionCoordinator
      else { return }

    self.presentedViewController.view.roundTopCorners(radius: Constants.topCornerRadius)
    self.addChevronView()

    self.dimmingView = UIView(frame: containerView.frame)
    self.dimmingView!.backgroundColor = CardPanelConstants.Presenter.backgroundColor
    self.dimmingView!.alpha = 0

    containerView.addSubview(self.dimmingView!)

    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.dimmingView!.alpha = CardPanelConstants.Presenter.backgroundAlpha
    }, completion: nil)
  }

  private func addChevronView() {
    guard let presentable = self.presentable,
              presentable.shouldShowChevronView
      else { return }

    self.chevronView = ChevronView()
    self.chevronView!.state = .down
    self.chevronView!.color = Managers.theme.colors.accentLight
    self.chevronView!.animationDuration = 0.1

    presentable.header.addSubview(self.chevronView!)
    self.chevronView!.snp.makeConstraints { make in
      let chevronViewSize = ChevronView.nominalSize

      make.top.equalToSuperview().offset(8.0)
      make.centerX.equalToSuperview()
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }
  }

  // MARK: - Dismissal

  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentingViewController.transitionCoordinator
      else { return }

    self.chevronView?.setState(.flat, animated: false)

    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.dimmingView?.alpha = 0
    }, completion: nil)
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    self.chevronView?.setState(.down, animated: true)

    if completed {
      self.dimmingView?.removeFromSuperview()
      self.dimmingView = nil
      self.chevronView?.removeFromSuperview()
      self.chevronView = nil
    }
  }
}
