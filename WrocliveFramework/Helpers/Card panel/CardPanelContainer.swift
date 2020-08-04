// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import UIKit
import SnapKit

public final class CardPanelContainer: UIViewController, CustomCardPanelPresentable {

  // MARK: - Properties

  public let chevronView = ChevronView()

  private var chevronViewContainer: UIVisualEffectView = {
    let blur = UIBlurEffect(style: Theme.colors.blurStyle)
    return UIVisualEffectView(effect: blur)
  }()

  private var child: UIViewController?
  private let childContainer = UIView()

  private var childCard: CustomCardPanelPresentable? {
    return self.child as? CustomCardPanelPresentable
  }

  // MARK: - Init

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.initLayout()
  }

  private func initLayout() {
    self.view.backgroundColor = Theme.colors.background
    self.view.roundTopCorners(radius: CardPanelConstants.Layout.topCornerRadius)

    self.view.addSubview(self.chevronViewContainer)
    self.chevronViewContainer.setContentHuggingPriority(900, for: .vertical)
    self.chevronViewContainer.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.chevronView.setState(.down)
    self.chevronView.color = Theme.colors.accentLight

    self.chevronViewContainer.contentView.addSubview(self.chevronView)
    self.chevronView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8.0)
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
      make.width.equalTo(ChevronView.nominalSize.width)
      make.height.equalTo(ChevronView.nominalSize.height)
    }

    self.view.addSubview(self.childContainer)
    self.childContainer.snp.makeConstraints { make in
      make.top.equalTo(self.chevronViewContainer.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

  // MARK: - Methods

  public func setContent(_ controller: UIViewController) {
    guard self.child == nil else {
      fatalError("Card panel content was already set!")
    }

    self.child = controller
    self.addChild(controller)

    self.childContainer.addSubview(controller.view)
    controller.view.snp.makeConstraints { $0.edges.equalToSuperview() }
    controller.didMove(toParent: self)
  }

  // MARK: - CustomCardPanelPresentable

  public var scrollView: UIScrollView? {
    return self.childCard?.scrollView
  }

  public func interactiveDismissalWillBegin() {
    self.childCard?.interactiveDismissalWillBegin()
  }

  public func interactiveDismissalProgress(percent: CGFloat) {
    self.updateChevronViewDuringInteractiveDismissal(percent: percent)
    self.childCard?.interactiveDismissalProgress(percent: percent)
  }

  public func interactiveDismissalDidEnd(completed: Bool) {
    self.updateChevronViewAfterInteractiveDismissal()
    self.childCard?.interactiveDismissalDidEnd(completed: completed)
  }

  private func updateChevronViewDuringInteractiveDismissal(percent: CGFloat) {
    // we assume that before we start chevron is in '.down' position
    let makeChevronFlatAt = CGFloat(0.75)
    let chevronPercent = CGFloat.minimum(percent, makeChevronFlatAt)
    self.chevronView.angle = -ChevronView.maxAngle * (makeChevronFlatAt - chevronPercent)
  }

  private func updateChevronViewAfterInteractiveDismissal() {
    self.chevronView.setState(.down)
  }
}
