// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

public final class CardPanelContainer: UIViewController, UIGestureRecognizerDelegate {

  // MARK: - Properties

  /// Animated arrow at the top of the card.
  public let chevronView = ChevronView()
  private var child: CardPanelPresentable?

  private let dismissGesture = UIPanGestureRecognizer()
  private var dismissGestureHandler: DismissGestureHandler?

  private let onViewDidDisappear: () -> Void

  // MARK: - Init

  public init(onViewDidDisappear: @escaping () -> Void) {
    self.onViewDidDisappear = onViewDidDisappear
    super.init(nibName: nil, bundle: nil)
  }

  // swiftlint:disable:next unavailable_function
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - ViewDidLoad

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
    self.initDismissGestureRecognizer()
  }

  private func initLayout() {
    self.view.backgroundColor = ColorScheme.background
    self.view.roundTopCorners(radius: CardPanelConstants.topCornerRadius)

    self.chevronView.setState(.down)

    self.view.addSubview(self.chevronView)
    self.chevronView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(CardPanelConstants.chevronViewTopOffset)
      make.centerX.equalToSuperview()
      make.width.equalTo(ChevronView.nominalSize.width)
      make.height.equalTo(ChevronView.nominalSize.height)
    }
  }

  private func initDismissGestureRecognizer() {
    self.dismissGesture.addTarget(self, action: #selector(self.handleDismissGesture))
    self.dismissGesture.maximumNumberOfTouches = 1
    self.dismissGesture.cancelsTouchesInView = false
    self.view.addGestureRecognizer(self.dismissGesture)
  }

  // MARK: - ViewDidDisappear

  override public func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.onViewDidDisappear()
  }

  // MARK: - Content

  public func setContent(_ controller: CardPanelPresentable) {
    guard self.child == nil else {
      fatalError("Card panel content was already set!")
    }

    self.child = controller
    self.addChild(controller)

    // 'controller.view' has to be below 'self.chevronView',
    // otherwise it would cover it.
    self.view.insertSubview(controller.view, belowSubview: self.chevronView)
    controller.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    controller.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    controller.didMove(toParent: self)
  }

  // MARK: - Dismiss gesture

  @objc
  private func handleDismissGesture(_ gesture: UIPanGestureRecognizer) {
    guard self.isDismissGesture(gesture) else {
      return
    }

    if gesture.state == .began {
      self.dismissGestureHandler = {
        if let scrollView = self.child?.scrollView {
          return ScrollViewDismissGestureHandler(cardPanel: self, scrollView: scrollView)
        }

        return DismissGestureHandler(cardPanel: self)
      }()
    }

    // If we are reordering cells then reorder has bigger priority than dismiss.
    // Please note that we do not know if we are reordeing, untill AFTER
    // the gesture has already started (so not in 'gesture.state == .began' case).
    if !self.isReorderingTableViewCells() {
      self.dismissGestureHandler?.handleGesture(gesture)
    }
  }

  private func isReorderingTableViewCells() -> Bool {
    guard let tableView = self.child?.scrollView as? UITableView else {
      return false
    }

    return tableView.isEditing && tableView.hasUncommittedUpdates
  }

  // MARK: - UIGestureRecognizerDelegate

  public func gestureRecognizerShouldBegin(
    _ gestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return self.isDismissGesture(gestureRecognizer)
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return self.isDismissGesture(gestureRecognizer)
  }

  private func isDismissGesture(_ gesture: UIGestureRecognizer) -> Bool {
    return gesture.isEqual(dismissGesture)
  }

  // MARK: - CustomCardPanelPresentable

  internal func interactiveDismissalWillBegin() {
    self.child?.interactiveDismissalWillBegin()
  }

  internal func interactiveDismissalProgress(percent: CGFloat) {
    self.updateChevronViewDuringInteractiveDismissal(percent: percent)
    self.child?.interactiveDismissalProgress(percent: percent)
  }

  internal func interactiveDismissalDidEnd(completed: Bool) {
    self.updateChevronViewAfterInteractiveDismissal()
    self.child?.interactiveDismissalDidEnd(completed: completed)
  }

  private func updateChevronViewDuringInteractiveDismissal(percent: CGFloat) {
    // We assume that before we start chevron is in '.down' position
    let makeChevronFlatAt = CardPanelConstants.DismissGesture.makeChevronFlatPercent
    let chevronPercent = CGFloat.minimum(percent, makeChevronFlatAt)
    self.chevronView.angle = -ChevronView.maxAngle * (makeChevronFlatAt - chevronPercent)
  }

  private func updateChevronViewAfterInteractiveDismissal() {
    self.chevronView.setState(.down)
  }
}
