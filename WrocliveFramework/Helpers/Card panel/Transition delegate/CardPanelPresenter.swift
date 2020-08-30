// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit

internal final class CardPanelPresenter:
  UIPresentationController, UIGestureRecognizerDelegate {

  // MARK: - Properties

  private let height: CGFloat
  private let cardPanel: CardPanelContainer
  /// Dark transparent background behind the card.
  private var dimmingView: UIView?

  private var dismissGesture: UIPanGestureRecognizer?
  private var dismissGestureHandler: DismissGestureHandler?

  // MARK: - Init

  internal init(forPresented cardPanel: CardPanelContainer,
                presenting: UIViewController?,
                height: CGFloat) {
    self.height = height
    self.cardPanel = cardPanel
    super.init(presentedViewController: cardPanel, presenting: presenting)
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

  // MARK: - Presentation transition did end

  // Add dismiss gesture recognizer
  override internal func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
    guard completed else { return }

    // swiftlint:disable force_unwrapping
    self.dismissGesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(self.handleDismissGesture)
    )
    self.dismissGesture!.maximumNumberOfTouches = 1
    self.dismissGesture!.cancelsTouchesInView = false
    self.dismissGesture!.delegate = self

    self.presentedView?.addGestureRecognizer(self.dismissGesture!)
    // swiftlint:enable force_unwrapping
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

  // MARK: - Dismiss gesture

  @objc
  private func handleDismissGesture(_ gesture: UIPanGestureRecognizer) {
    guard self.isDismissGesture(gesture) else {
      return
    }

    if gesture.state == .began {
      self.dismissGestureHandler = self.createDismissGestureHandler(for: gesture)
    }

    // If we are reordering cells then reorder has bigger priority than dismiss.
    // Please note that we do not know if we are reordeing, untill AFTER
    // the gesture has already started (so not in 'gesture.state == .began' case).
    if !self.isReorderingTableViewCells() {
      self.dismissGestureHandler?.handleGesture(gesture)
    }
  }

  private func createDismissGestureHandler(
    for gesture: UIPanGestureRecognizer
  ) -> DismissGestureHandler {
    // No scroll view -> DismissGestureHandler
    guard let scrollView = self.cardPanel.scrollView else {
      return DismissGestureHandler(cardPanel: self.cardPanel)
    }

    // If user is dragging header view -> DismissGestureHandler
    let headerInset = scrollView.contentInset.top
    let location = gesture.location(in: self.cardPanel.view)
    let isDraggingHeaderView = location.y < headerInset

    if isDraggingHeaderView {
      return DismissGestureHandler(cardPanel: self.cardPanel)
    }

    // Hard case: we have to handle gesture alongside scroll view
    return ScrollViewDismissGestureHandler(
      cardPanel: self.cardPanel,
      scrollView: scrollView
    )
  }

  private func isReorderingTableViewCells() -> Bool {
    guard let tableView = self.cardPanel.scrollView as? UITableView else {
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
    guard let dismissGesture = self.dismissGesture else {
      return false
    }

    return gesture.isEqual(dismissGesture)
  }
}
