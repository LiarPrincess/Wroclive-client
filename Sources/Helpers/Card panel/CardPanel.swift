//
//  Created by Michal Matuszczyk
//  Copyright © 2018 Michal Matuszczyk. All rights reserved.
//

import UIKit

private typealias Layout             = CardPanelConstants.Layout
private typealias AnimationDurations = CardPanelConstants.AnimationDurations

class CardPanel: UIViewController {

  // MARK: - Properties

  let chevronView          = ChevronView()
  let chevronViewContainer = UIView()

  var height: CGFloat { return 0.5 * AppEnvironment.device.screenBounds.height }

  var scrollView: UIScrollView? { return nil }

  var presentationDuration: TimeInterval { return AnimationDurations.present }
  var dismissalDuration:    TimeInterval { return AnimationDurations.dismiss }

  // MARK: - Init

  // MARK: - Overriden

  override func viewDidLoad() {
    super.viewDidLoad()

    self.roundTopCorners()
    self.addChevronView()
  }

  private func roundTopCorners() {
    self.view.roundTopCorners(radius: Layout.topCornerRadius)
  }

  private func addChevronView() {
    self.view.addSubview(self.chevronViewContainer)
    self.chevronViewContainer.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    self.chevronView.state = .down
    self.chevronView.color = AppEnvironment.theme.colors.accentLight
    self.chevronView.animationDuration = 0.1

    self.chevronViewContainer.addSubview(self.chevronView)
    self.chevronView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8.0)
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()

      let chevronViewSize = ChevronView.nominalSize
      make.width.equalTo(chevronViewSize.width)
      make.height.equalTo(chevronViewSize.height)
    }
  }

  // MARK: - Presentation

  func presentationWillBegin() { }
  func presentationDidEnd()    { }

  // MARK: - Dismiss gesture

  func dismissalGestureWillBegin() {
    self.chevronView.setState(.flat, animated: true)
  }

  func dismissalGestureDidEnd() {
    self.chevronView.setState(.down, animated: true)
  }
}
