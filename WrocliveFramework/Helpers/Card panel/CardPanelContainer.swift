// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

public final class CardPanelContainer: UIViewController {

  // MARK: - Properties

  /// Animated arrow at the top of the card.
  public let chevronView = ChevronView()
  private var child: CardPanelPresentable?

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
  }

  private func initLayout() {
    self.view.backgroundColor = ColorScheme.background

    self.chevronView.setState(.down)

    self.view.addSubview(self.chevronView)
    self.chevronView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(CardPanelConstants.chevronViewTopOffset)
      make.centerX.equalToSuperview()
      make.width.equalTo(ChevronView.nominalSize.width)
      make.height.equalTo(ChevronView.nominalSize.height)
    }
  }

  // MARK: - ViewDidLayoutSubviews

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // This has to be in 'viewDidLayoutSubviews' because it uses 'view.bounds'.
    let radius = CardPanelConstants.topCornerRadius
    self.view.roundTopCorners(radius: radius)
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
    controller.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    controller.didMove(toParent: self)
  }

  // MARK: - CustomCardPanelPresentable

  internal var scrollView: UIScrollView? {
    return self.child?.scrollView
  }

  internal func interactiveDismissalWillBegin() {
    self.child?.interactiveDismissalWillBegin()
  }

  internal func interactiveDismissalProgress(percent: CGFloat) {
    // We assume that before we start chevron is in '.down' position
    let makeChevronFlatAt = CardPanelConstants.DismissGesture.makeChevronFlatPercent
    let chevronPercent = CGFloat.minimum(percent, makeChevronFlatAt)
    self.chevronView.angle = -ChevronView.maxAngle * (makeChevronFlatAt - chevronPercent)

    self.child?.interactiveDismissalProgress(percent: percent)
  }

  internal func interactiveDismissalDidEnd(completed: Bool) {
    self.chevronView.setState(.down)
    self.child?.interactiveDismissalDidEnd(completed: completed)
  }
}
