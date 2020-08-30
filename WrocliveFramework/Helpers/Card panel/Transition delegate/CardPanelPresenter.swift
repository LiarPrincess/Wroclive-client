// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal final class CardPanelPresenter: UIPresentationController {

  // MARK: - Properties

  private let height: CGFloat
  /// Dark transparent background behind the card.
  private var dimmingView: UIView?

  // MARK: - Init

  internal init(forPresented presented: UIViewController,
                presenting: UIViewController?,
                height: CGFloat) {
    self.height = height
    super.init(presentedViewController: presented, presenting: presenting)
  }

  // MARK: - Frame of presented view in container view

  override internal var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return .zero
    }

    return CGRect(x: 0.0,
                  y: containerView.bounds.height - self.height,
                  width: containerView.bounds.width,
                  height: self.height)
  }

  // MARK: - Presentation transition will begin

  // Prepare dimming view
  override internal func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()

    guard let containerView = self.containerView,
          let coordinator = self.presentingViewController.transitionCoordinator else {
      return
    }

    // swiftlint:disable force_unwrapping
    self.dimmingView = UIView(frame: containerView.frame)
    self.dimmingView!.backgroundColor = CardPanelConstants.DimmingView.color
    self.dimmingView!.alpha = 0
    containerView.addSubview(self.dimmingView!)
    // swiftlint:enable force_unwrapping

    coordinator.animate(
      alongsideTransition: { [weak self] _ in
        self?.dimmingView?.alpha = CardPanelConstants.DimmingView.alpha
      },
      completion: nil
    )
  }

  // MARK: - Dismissal transition will begin

  // Hide dimming view
  override internal func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()

    guard let coordinator = presentingViewController.transitionCoordinator else {
      return
    }

    coordinator.animate(
      alongsideTransition: { [weak self] _ in
        self?.dimmingView?.alpha = 0
      },
      completion: nil
    )
  }

  // Remove dimming view
  override internal func dismissalTransitionDidEnd(_ completed: Bool) {
    super.dismissalTransitionDidEnd(completed)

    if completed {
      self.dimmingView?.removeFromSuperview()
      self.dimmingView = nil
    }
  }
}
