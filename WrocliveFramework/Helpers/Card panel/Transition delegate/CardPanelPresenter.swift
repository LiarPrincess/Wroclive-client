// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout = CardPanelConstants.Layout

internal final class CardPanelPresenter:
  UIPresentationController, UIGestureRecognizerDelegate
{

  // MARK: - Properties

  private let height: CGFloat

  private var dimmingView: UIView?

  private var dismissGesture: UIPanGestureRecognizer?
  private var dismissGestureHandler: DismissGestureHandlerType?

  private var cardPanel: CustomCardPanelPresentable? {
    return self.presentedViewController as? CustomCardPanelPresentable
  }

  // MARK: - Init

  internal init(forPresented presented: UIViewController,
              presenting: UIViewController?,
              height: CGFloat) {
    self.height = height
    super.init(presentedViewController: presented, presenting: presenting)
  }

  // MARK: - Frame

  internal override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      return .zero
    }

    return CGRect(x: 0.0,
                  y: containerView.bounds.height - self.height,
                  width: containerView.bounds.width,
                  height: self.height)
  }

  // MARK: - Present

  // Prepare dimming view
  internal override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()

    guard let containerView = self.containerView,
          let coordinator   = self.presentingViewController.transitionCoordinator
      else { return }

    self.dimmingView = UIView(frame: containerView.frame)
    self.dimmingView!.backgroundColor = Layout.DimmingView.color
    self.dimmingView!.alpha = 0
    containerView.addSubview(self.dimmingView!)

    coordinator.animate(
      alongsideTransition: { [unowned self] _ in
        self.dimmingView!.alpha = Layout.DimmingView.alpha
      },
      completion: nil
    )
  }

  // Add dismiss gesture recognizer
  internal override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    guard completed else { return }

    self.dismissGesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(handleDismissGesture)
    )
    self.dismissGesture!.maximumNumberOfTouches = 1
    self.dismissGesture!.cancelsTouchesInView   = false
    self.dismissGesture!.delegate               = self

    self.presentedView?.addGestureRecognizer(self.dismissGesture!)
  }

  // MARK: - Dismiss

  // Hide dimming view
  internal override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()

    guard let coordinator = presentingViewController.transitionCoordinator
      else { return }

    coordinator.animate(
      alongsideTransition: { [weak self] _ in self?.dimmingView?.alpha = 0},
      completion: nil
    )
  }

  // Remove dimming view
  internal override func dismissalTransitionDidEnd(_ completed: Bool) {
    super.dismissalTransitionDidEnd(completed)

    if completed {
      self.dimmingView?.removeFromSuperview()
      self.dimmingView = nil
    }
  }

  // MARK: - Dismiss gesture

  @objc
  private func handleDismissGesture(_ gesture: UIPanGestureRecognizer) {
    guard let dismissGesture = self.dismissGesture, gesture.isEqual(dismissGesture)
      else { return }

    if gesture.state == .began {
      let scrollView = self.cardPanel?.scrollView
      self.dismissGestureHandler = scrollView == nil ?
            DismissGestureHandler(for: self.presentedViewController) :
            ScrollViewDismissGestureHandler(for: self.presentedViewController,
                                            scrollView: scrollView!)
    }

    // If we are reordering cells then reorder has bigger priority than dismiss.
    // Please note that we do not know if we are reordeing, untill AFTER
    // the gesture has already started (so not in 'gesture.state == .began' case).
    if !self.isReorderingTableViewCells() {
      self.dismissGestureHandler?.handleGesture(gesture)
    }
  }

  private func isReorderingTableViewCells() -> Bool {
    guard let tableView = self.cardPanel?.scrollView as? UITableView else {
      return false
    }

    return tableView.isEditing && tableView.hasUncommittedUpdates
  }

  // MARK: - UIGestureRecognizerDelegate

  internal func gestureRecognizerShouldBegin(
    _ gestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return self.isDismissGesture(gestureRecognizer)
  }

  internal func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return self.isDismissGesture(gestureRecognizer)
  }

  private func isDismissGesture(_ gesture: UIGestureRecognizer) -> Bool {
    return self.dismissGesture != nil
        && self.dismissGesture!.isEqual(gesture)
  }
}