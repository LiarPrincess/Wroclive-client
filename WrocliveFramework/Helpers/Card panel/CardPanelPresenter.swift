// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

private typealias Layout = CardPanelConstants.Layout

public final class CardPanelPresenter : UIPresentationController, UIGestureRecognizerDelegate {

  // MARK: - Properties

  private var dimmingView: UIView?

  private var dismissGesture:        UIPanGestureRecognizer?
  private var dismissGestureHandler: DismissGestureHandlerType?

  private weak var cardPanel: CardPanel! // swiftlint:disable:this implicitly_unwrapped_optional

  // MARK: - Init

  public init(forPresented presented: UIViewController, presenting: CardPanel) {
    self.cardPanel = presenting
    super.init(presentedViewController: presented, presenting: presenting)
  }

  // MARK: - Frame

  public override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView
      else { return .zero }

    let containerViewBounds = containerView.bounds
    let cardPanelHeight     = self.cardPanel.height
    return CGRect(x:      0.0,
                  y:      containerViewBounds.height - cardPanelHeight,
                  width:  containerView.bounds.width,
                  height: cardPanelHeight)
  }

  // MARK: - Present

  public override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()

    guard let containerView = self.containerView,
      let coordinator   = self.presentingViewController.transitionCoordinator
      else { return }

    self.dimmingView = UIView(frame: containerView.frame)
    self.dimmingView!.backgroundColor = Layout.DimmingView.color
    self.dimmingView!.alpha = 0

    containerView.addSubview(self.dimmingView!)

    self.cardPanel.presentationWillBegin()
    coordinator.animate(
      alongsideTransition: { [weak self] _ in self?.dimmingView!.alpha = Layout.DimmingView.alpha },
      completion:          nil
    )
  }

  public override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)

    self.dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismissGesture))
    self.dismissGesture!.maximumNumberOfTouches = 1
    self.dismissGesture!.cancelsTouchesInView   = false
    self.dismissGesture!.delegate               = self
    self.cardPanel.view.addGestureRecognizer(self.dismissGesture!)

    self.cardPanel.presentationDidEnd()
  }

  // MARK: - Dismiss

  public override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()

    guard let coordinator = presentingViewController.transitionCoordinator
      else { return }

    coordinator.animate(
      alongsideTransition: { [weak self] _ in self?.dimmingView?.alpha = 0},
      completion:          nil
    )
  }

  public override func dismissalTransitionDidEnd(_ completed: Bool) {
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

    // it does not work in 'shouldRecognizeSimultaneouslyWith' as those fields are set later
    if self.isReorderingTableViewCells() {
      return
    }

    if gesture.state == .began {
      self.dismissGestureHandler = createDismissGestureHandler(gesture)
    }

    self.dismissGestureHandler?.handleGesture(gesture)
  }

  private func createDismissGestureHandler(_ gesture: UIPanGestureRecognizer) -> DismissGestureHandlerType {
    return self.cardPanel.scrollView == nil ?
      DismissGestureHandler(for: self.cardPanel) :
      ScrollViewDismissGestureHandler(for: self.cardPanel)
  }

  private func isReorderingTableViewCells() -> Bool {
    guard let tableView = self.cardPanel.scrollView as? UITableView
      else { return false }

    if #available(iOS 11.0, *) {
      return tableView.isEditing && tableView.hasUncommittedUpdates
    }

    // HACK: [iOS 10] Find if we are currently reordering cells
    let reorderingSupport = tableView.value(forKey: "_reorderingSupport")      as? NSObject
    let reorderedCell     = reorderingSupport?.value(forKey: "_reorderedCell") as? NSObject
    return tableView.isEditing && reorderedCell != nil
  }

  // MARK: - UIGestureRecognizerDelegate

  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.isDismissGesture(gestureRecognizer)
        && self.isScrollViewPanGesture(otherGestureRecognizer)
  }

  private func isDismissGesture(_ gesture: UIGestureRecognizer) -> Bool {
    return self.dismissGesture != nil
        && self.dismissGesture!.isEqual(gesture)
  }

  private func isScrollViewPanGesture(_ gesture: UIGestureRecognizer) -> Bool {
    let scrollViewPanGesture = self.cardPanel.scrollView?.panGestureRecognizer
    return scrollViewPanGesture != nil
        && scrollViewPanGesture!.isEqual(gesture)
  }
}
